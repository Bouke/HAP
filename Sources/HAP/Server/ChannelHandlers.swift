import Dispatch
import Foundation
import HTTP
import Logging
import NIO
import NIOHTTP1
import Crypto

fileprivate let logger = Logger(label: "hap.nio")

enum CryptographyEvent {
    case sharedKey(Data)
}

class CryptographerHandler: ChannelDuplexHandler {
    typealias InboundIn = ByteBuffer
    typealias InboundOut = ByteBuffer
    typealias OutboundIn = ByteBuffer
    typealias OutboundOut = ByteBuffer

    var cryptographer: Cryptographer?
    var cumulationBuffer: ByteBuffer?

    func triggerUserOutboundEvent(context: ChannelHandlerContext, event: Any, promise: EventLoopPromise<Void>?) {
        if case let CryptographyEvent.sharedKey(sharedKey) = event {
            cryptographer = Cryptographer(sharedSecret: SymmetricKey(data: sharedKey))
            promise?.succeed(())
        } else {
            context.triggerUserOutboundEvent(event, promise: promise)
        }
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        guard cryptographer != nil else {
            return context.fireChannelRead(data)
        }

        var buffer = unwrapInboundIn(data)
        if cumulationBuffer == nil {
            cumulationBuffer = buffer
        } else {
            cumulationBuffer!.writeBuffer(&buffer)
        }

        repeat {
            let startIndex = cumulationBuffer!.readerIndex
            guard let length = cumulationBuffer!.readInteger(endianness: Endianness.little, as: Int16.self) else {
                return // not enough bytes available
            }
            cumulationBuffer!.moveReaderIndex(to: startIndex)
            guard 2 + length + 16 <= cumulationBuffer!.readableBytes else {
                return // not enough bytes available
            }
            readOneFrame(context: context, length: Int(length))
        } while cumulationBuffer != nil
    }

    func readOneFrame(context: ChannelHandlerContext, length: Int) {
        let lengthBytes = cumulationBuffer!.readSlice(length: 2)!
        let cyphertext = cumulationBuffer!.readSlice(length: length)!
        let tag = cumulationBuffer!.readSlice(length: 16)!

        var message: Data
        do {
            message = try cryptographer!.decrypt(lengthBytes: lengthBytes.readableBytesView,
                                                 ciphertext: cyphertext.readableBytesView,
                                                 tag: tag.readableBytesView)
        } catch {
            // swiftlint:disable:next line_length
            logger.warning("Could not decrypt message from \(context.remoteAddress?.description ?? "???"): \(error), closing connection.")
            cumulationBuffer!.clear()
            context.close(promise: nil)
            return
        }

        context.fireChannelRead(wrapInboundOut(ByteBuffer(data: message)))

        if cumulationBuffer!.readableBytes == 0 {
            cumulationBuffer = nil
        }
    }

    func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        guard cryptographer != nil else {
            return context.write(data, promise: promise)
        }

        var buffer = unwrapOutboundIn(data)
        while buffer.readableBytes > 0 {
            writeOneFrame(context: context, buffer: &buffer, promise: promise)
        }
    }

    func writeOneFrame(context: ChannelHandlerContext, buffer: inout ByteBuffer, promise: EventLoopPromise<Void>?) {
        let length = min(1024, buffer.readableBytes)

        let frame = buffer.readSlice(length: length)!

        var cipher: Data
        do {
            cipher = try cryptographer!.encrypt(plaintext: frame)
        } catch {
            // swiftlint:disable:next line_length
            logger.warning("Could not decrypt message from \(context.remoteAddress?.description ?? "???"): \(error), closing connection.")
            buffer.clear()
            context.close(promise: nil)
            return
        }

        if buffer.readableBytes > 0 {
            context.write(wrapOutboundOut(ByteBuffer(data: cipher)), promise: nil)
        } else {
            context.write(wrapOutboundOut(ByteBuffer(data: cipher)), promise: promise)
        }
    }
}

class EventHandler: ChannelOutboundHandler {
    typealias OutboundIn = ByteBuffer
    typealias OutboundOut = ByteBuffer

    var pendingNotifications: [Characteristic] = []
    var pendingPromises: [EventLoopPromise<Void>] = []
    var nextAllowableNotificationTime = Date()

    func triggerUserOutboundEvent(context: ChannelHandlerContext, event: Any, promise: EventLoopPromise<Void>?) {
        if case let CharacteristicEvent.changed(characteristic) = event {
            pendingNotifications.append(characteristic)
            if let promise = promise {
                pendingPromises.append(promise)
            }

            // We don't send notifications immediately to allow a small window
            // to receive additional events, otherwise those events would have
            // to wait for the next opportunity.
            _ = context.eventLoop.scheduleTask(in: TimeAmount.milliseconds(5)) {
                self.writePendingNotifications(context: context)
            }
        } else {
            context.triggerUserOutboundEvent(event, promise: promise)
        }
    }

    func writePendingNotifications(context: ChannelHandlerContext) {
        /* HAP Specification 5.8 (excerpts)
         Network-based notifications must be coalesced
         by the accessory using a delay of no less than 1 second.
         Excessive or inappropriate notifications may result
         in the user being notified of a misbehaving
         accessory and/or termination of the pairing relationship.
         */
        if pendingNotifications.isEmpty {
            return
        }

        if nextAllowableNotificationTime > Date() {
            let waitms = nextAllowableNotificationTime.timeIntervalSinceNow * 1000
            _ = context.eventLoop.scheduleTask(in: TimeAmount.milliseconds(Int64(waitms))) {
                self.writePendingNotifications(context: context)
            }
            return
        }

        // swiftlint:disable:next line_length
        logger.debug("Writing \(self.pendingNotifications.count) notification to \(context.remoteAddress?.description ?? "N/A")")

        guard let event = try? Event(valueChangedOfCharacteristics: pendingNotifications) else {
            // swiftlint:disable:next line_length
            logger.warning("Could not serialize events for \(context.remoteAddress?.description ?? "N/A"), closing connection.")
            return
        }
        let serialized = event.serialized()
        var buffer = context.channel.allocator.buffer(capacity: serialized.count)
        buffer.writeBytes(serialized)
        context.writeAndFlush(wrapOutboundOut(buffer), promise: nil)

        for promise in pendingPromises {
            promise.succeed(())
        }

        pendingNotifications = []
        nextAllowableNotificationTime = Date(timeIntervalSinceNow: 1)
    }
}

enum PairingEvent {
    case verified(Pairing)
}

enum CharacteristicEvent {
    case changed(Characteristic)
}

class ControllerHandler: ChannelDuplexHandler {
    typealias InboundIn = HTTPServerRequestPart
    typealias OutboundIn = HTTPServerResponsePart

    // All access to channels is guarded by channelsSyncQueue.
    private let channelsSyncQueue = DispatchQueue(label: "channelsQueue")
    private var channels: [ObjectIdentifier: Channel] = [:]
    private var pairings: [ObjectIdentifier: Pairing] = [:]

    // TODO: tighter integration into Device.
    internal var removeSubscriptions: ((Channel) -> Void)?

    func channelActive(context: ChannelHandlerContext) {
        let channel = context.channel
        var channelsCount = 0
        channelsSyncQueue.sync {
            self.channels[ObjectIdentifier(channel)] = channel
            channelsCount = self.channels.count
        }
        logger.info("Controller \(channel.remoteAddress?.description ?? "N/A") connected, \(channelsCount) controllers total")
        context.fireChannelActive()
    }

    func channelInactive(context: ChannelHandlerContext) {
        let channel = context.channel
        var channelsCount = 0
        channelsSyncQueue.sync {
            self.channels.removeValue(forKey: ObjectIdentifier(channel))
            self.pairings.removeValue(forKey: ObjectIdentifier(channel))
            channelsCount = self.channels.count
        }
        self.removeSubscriptions?(channel)
        logger.info("Controller \(channel.remoteAddress?.description ?? "N/A") disconnected, \(channelsCount) controllers total")
        context.fireChannelInactive()
    }

    func triggerUserOutboundEvent(context: ChannelHandlerContext, event: Any, promise: EventLoopPromise<Void>?) {
        if case let PairingEvent.verified(pairing) = event {
            let channel = context.channel
            registerPairing(pairing, forChannel: channel)
        } else {
            context.triggerUserOutboundEvent(event, promise: promise)
        }
    }

    func isChannelVerified(channel: Channel) -> Bool {
        channelsSyncQueue.sync {
            pairings.keys.contains(ObjectIdentifier(channel))
        }
    }

    func notifyChannel(identifier: ObjectIdentifier, ofCharacteristicChange characteristic: Characteristic) {
        channelsSyncQueue.sync {
            guard let channel = self.channels[identifier] else {
                // todo... probably need to clean up?
                logger.error("event for non-existing channel")
                return
            }
            channel.triggerUserOutboundEvent(CharacteristicEvent.changed(characteristic), promise: nil)
        }
    }

    func getPairingForChannel(_ channel: Channel) -> Pairing? {
        channelsSyncQueue.sync {
            self.pairings[ObjectIdentifier(channel)]
        }
    }

    func registerPairing(_ pairing: Pairing, forChannel channel: Channel) {
        channelsSyncQueue.sync {
            self.pairings[ObjectIdentifier(channel)] = pairing
        }
    }

    func disconnectPairing(_ pairing: Pairing) {
        var channelsToClose = [Channel]()
        channelsSyncQueue.sync {
            let channelIdentifiers = pairings.filter { $0.value.identifier == pairing.identifier }.keys
            channelsToClose = channelIdentifiers.compactMap({ channels[$0] })
        }
        for channel in channelsToClose {
            // This will trigger `channelInactive(context:)`.
            channel.close(promise: nil)
        }

    }
}

// Abuse response headers to trigger outbound event AFTER the response itself was
// written to the channel. Ideally we'd expose the `Future` to the `Responder`,
// so itself can trigger this event instead.
class UpgradeEventHandler: ChannelOutboundHandler {
    typealias OutboundIn = HTTPResponse
    typealias OutboundOut = HTTPResponse

    func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        var response = unwrapOutboundIn(data)
        if let sharedKeyB64 = response.headers["x-shared-key"].first {
            let sharedKey = Data(base64Encoded: sharedKeyB64)!
            response.headers.remove(name: "x-shared-key")
            context.write(wrapOutboundOut(response)).whenSuccess {
                context.triggerUserOutboundEvent(CryptographyEvent.sharedKey(sharedKey), promise: nil)
            }
        } else {
            context.write(wrapOutboundOut(response), promise: nil)
        }
    }
}

typealias Responder = (RequestContext, HTTPRequest) -> HTTPResponse

class ApplicationHandler: ChannelInboundHandler {
    typealias InboundIn = HTTPRequest
    typealias OutboundOut = HTTPResponse

    let responder: Responder

    init(responder: @escaping Responder) {
        self.responder = responder
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let request = unwrapInboundIn(data)
        context.write(wrapOutboundOut(responder(context, request)), promise: nil)
    }
}

protocol RequestContext {
    var channel: Channel { get }
    func triggerUserOutboundEvent(_ event: Any, promise: EventLoopPromise<Void>?)
}

extension ChannelHandlerContext: RequestContext { }
