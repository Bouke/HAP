import Logging
import Dispatch
import Foundation
import HTTP
import NIO
import NIOHTTP1

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

    func triggerUserOutboundEvent(ctx: ChannelHandlerContext, event: Any, promise: EventLoopPromise<Void>?) {
        if case let CryptographyEvent.sharedKey(sharedKey) = event {
            cryptographer = Cryptographer(sharedKey: sharedKey)
            promise?.succeed(result: ())
        } else {
            ctx.triggerUserOutboundEvent(event, promise: promise)
        }
    }

    func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        guard cryptographer != nil else {
            return ctx.fireChannelRead(data)
        }

        var buffer = unwrapInboundIn(data)
        if cumulationBuffer == nil {
            cumulationBuffer = buffer
        } else {
            cumulationBuffer!.write(buffer: &buffer)
        }

        repeat {
            let startIndex = cumulationBuffer!.readerIndex
            guard let length = cumulationBuffer!.readInteger(endianness: Endianness.little, as: Int16.self) else { return }
            cumulationBuffer!.moveReaderIndex(to: startIndex)
            guard 2 + length + 16 <= cumulationBuffer!.readableBytes else { return }

            readOneFrame(ctx: ctx, length: Int(length))
        } while cumulationBuffer != nil
    }

    func readOneFrame(ctx: ChannelHandlerContext, length: Int) {
        var cipher = cumulationBuffer!.readSlice(length: 2 + length + 16)!
        var message = ctx.channel.allocator.buffer(capacity: length)
        do {
            try cryptographer!.decrypt(length: length, cipher: &cipher, message: &message)
        } catch {
            // swiftlint:disable:next line_length
            logger.warning("Could not decrypt message from \(ctx.remoteAddress?.description ?? "???"): \(error), closing connection.")
            cumulationBuffer!.clear()
            ctx.close(promise: nil)
            return
        }
        ctx.fireChannelRead(wrapInboundOut(message))

        if cumulationBuffer!.readableBytes == 0 {
            cumulationBuffer = nil
        }
    }

    func write(ctx: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        guard cryptographer != nil else {
            return ctx.write(data, promise: promise)
        }

        var buffer = unwrapOutboundIn(data)
        while (buffer.readableBytes > 0) {
            writeOneFrame(ctx: ctx, buffer: &buffer, promise: promise)
        }
    }

    func writeOneFrame(ctx: ChannelHandlerContext, buffer: inout ByteBuffer, promise: EventLoopPromise<Void>?) {
        let length = min(1024, buffer.readableBytes)
        var frame = buffer.readSlice(length: length)!
        var cipher = ctx.channel.allocator.buffer(capacity: 0)
        do {
            try cryptographer!.encrypt(length: length, plaintext: &frame, cipher: &cipher)
        } catch {
            // swiftlint:disable:next line_length
            logger.warning("Could not decrypt message from \(ctx.remoteAddress?.description ?? "???"): \(error), closing connection.")
            buffer.clear()
            ctx.close(promise: nil)
            return
        }

        if (buffer.readableBytes > 0) {
            ctx.write(wrapOutboundOut(cipher), promise: nil)
        } else {
            ctx.write(wrapOutboundOut(cipher), promise: promise)
        }
    }
}

class EventHandler: ChannelOutboundHandler {
    typealias OutboundIn = ByteBuffer
    typealias OutboundOut = ByteBuffer

    var pendingNotifications: [Characteristic] = []
    var pendingPromises: [EventLoopPromise<Void>] = []
    var nextAllowableNotificationTime = Date()

    func triggerUserOutboundEvent(ctx: ChannelHandlerContext, event: Any, promise: EventLoopPromise<Void>?) {
        if case let CharacteristicEvent.changed(characteristic) = event {
            pendingNotifications.append(characteristic)
            if let promise = promise {
                pendingPromises.append(promise)
            }

            // We don't send notifications immediately to allow a small window
            // to receive additional events, otherwise those events would have
            // to wait for the next opportunity.
            _ = ctx.eventLoop.scheduleTask(in: TimeAmount.milliseconds(5)) {
                self.writePendingNotifications(ctx: ctx)
            }
        } else {
            ctx.triggerUserOutboundEvent(event, promise: promise)
        }
    }

    func writePendingNotifications(ctx: ChannelHandlerContext) {
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
            let waitms = TimeAmount.Value(nextAllowableNotificationTime.timeIntervalSinceNow * 1000)
            _ = ctx.eventLoop.scheduleTask(in: TimeAmount.milliseconds(waitms)) {
                self.writePendingNotifications(ctx: ctx)
            }
            return
        }

        // swiftlint:disable:next line_length
        logger.debug("Writing \(self.pendingNotifications.count) notification to \(ctx.remoteAddress?.description ?? "N/A")")

        guard let event = try? Event(valueChangedOfCharacteristics: pendingNotifications) else {
            // swiftlint:disable:next line_length
            logger.warning("Could not serialize events for \(ctx.remoteAddress?.description ?? "N/A"), closing connection.")
            return
        }
        let serialized = event.serialized()
        var buffer = ctx.channel.allocator.buffer(capacity: serialized.count)
        buffer.write(bytes: serialized)
        ctx.writeAndFlush(wrapOutboundOut(buffer), promise: nil)

        for promise in pendingPromises {
            promise.succeed(result: ())
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

    func channelActive(ctx: ChannelHandlerContext) {
        let channel = ctx.channel
        var channelsCount = 0
        channelsSyncQueue.sync {
            self.channels[ObjectIdentifier(channel)] = channel
            channelsCount = self.channels.count
        }
        logger.info("Controller \(channel.remoteAddress?.description ?? "N/A") connected, \(channelsCount) controllers total")
        ctx.fireChannelActive()
    }

    func channelInactive(ctx: ChannelHandlerContext) {
        let channel = ctx.channel
        var channelsCount = 0
        channelsSyncQueue.sync {
            self.channels.removeValue(forKey: ObjectIdentifier(channel))
            self.pairings.removeValue(forKey: ObjectIdentifier(channel))
            channelsCount = self.channels.count
        }
        self.removeSubscriptions?(channel)
        logger.info("Controller \(channel.remoteAddress?.description ?? "N/A") disconnected, \(channelsCount) controllers total")
        ctx.fireChannelInactive()
    }

    func triggerUserOutboundEvent(ctx: ChannelHandlerContext, event: Any, promise: EventLoopPromise<Void>?) {
        if case let PairingEvent.verified(pairing) = event {
            let channel = ctx.channel
            registerPairing(pairing, forChannel: channel)
        } else {
            ctx.triggerUserOutboundEvent(event, promise: promise)
        }
    }

    func isChannelVerified(channel: Channel) -> Bool {
        return channelsSyncQueue.sync {
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
        return channelsSyncQueue.sync {
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
            channelsToClose = channelIdentifiers.compactMap( { channels[$0] } )
        }
        for channel in channelsToClose {
            // This will trigger `channelInactive(ctx:)`.
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

    func write(ctx: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        var response = unwrapOutboundIn(data)
        if let sharedKeyB64 = response.headers["x-shared-key"].first {
            let sharedKey = Data(base64Encoded: sharedKeyB64)!
            response.headers.remove(name: "x-shared-key")
            ctx.write(wrapOutboundOut(response)).whenSuccess {
                ctx.triggerUserOutboundEvent(CryptographyEvent.sharedKey(sharedKey), promise: nil)
            }
        } else {
            ctx.write(wrapOutboundOut(response), promise: nil)
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

    func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        let request = unwrapInboundIn(data)
        ctx.write(wrapOutboundOut(responder(ctx, request)), promise: nil)
    }
}

protocol RequestContext {
    var channel: Channel { get }
    func triggerUserOutboundEvent(_ event: Any, promise: EventLoopPromise<Void>?)
}

extension ChannelHandlerContext: RequestContext { }
