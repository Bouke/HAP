import func Evergreen.getLogger
import Dispatch
import Foundation
import HTTP
import NIO
import NIOHTTP1

fileprivate let logger = getLogger("hap.nio")

enum CryptographyEvent {
    case sharedKey(Data)
}

// TODO: use "cumulationBuffer" (similar to HTTPDecoder) and buffer until
// correct amount of bytes is received.
// TODO: merge with actual cryptographer.
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
        guard let cryptographer = cryptographer else {
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

            // TODO: don't copy bytes, but pass buffer slice instead
            let data = cumulationBuffer!.readData(length: Int(2 + length + 16))!
            guard let decrypted = try? cryptographer.decrypt(data) else {
                // swiftlint:disable:next line_length
                logger.warning("Could not decrypt message from \(ctx.remoteAddress?.description ?? "???"), closing connection.")
                ctx.close(promise: nil)
                return
            }
            // TODO: don't copy bytes, but pass buffer slice instead
            var out = ctx.channel.allocator.buffer(capacity: decrypted.count)
            out.write(bytes: decrypted)
            ctx.fireChannelRead(wrapInboundOut(out))

            if cumulationBuffer!.readableBytes == 0 {
                cumulationBuffer = nil
            }
        } while cumulationBuffer != nil
    }

    func write(ctx: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        guard let cryptographer = cryptographer else {
            return ctx.write(data, promise: promise)
        }

        var buffer = unwrapOutboundIn(data)
        let data = buffer.readData(length: buffer.readableBytes)!
        guard let encrypted = try? cryptographer.encrypt(data) else {
            // swiftlint:disable:next line_length
            logger.warning("Could not encrypt message to \(ctx.remoteAddress?.description ?? "???"), closing connection.")
            return
        }
        var out = ctx.channel.allocator.buffer(capacity: encrypted.count)
        out.write(bytes: encrypted)
        ctx.write(wrapOutboundOut(out), promise: promise)
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
        channelsSyncQueue.sync {
            self.channels[ObjectIdentifier(channel)] = channel
        }
        logger.info("Controller \(channel.remoteAddress?.description ?? "N/A") connected, \(self.channels.count) controllers total")
        ctx.fireChannelActive()
    }

    func channelInactive(ctx: ChannelHandlerContext) {
        let channel = ctx.channel
        channelsSyncQueue.sync {
            self.channels.removeValue(forKey: ObjectIdentifier(channel))
            self.pairings.removeValue(forKey: ObjectIdentifier(channel))
        }
        self.removeSubscriptions?(channel)
        logger.info("Controller \(channel.remoteAddress?.description ?? "N/A") disconnected, \(self.channels.count) controllers total")
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
        channelsSyncQueue.sync {
            let channelIdentifiers = pairings.filter { $0.value.identifier == pairing.identifier }.keys
            for channelIdentifier in channelIdentifiers {
                // This will trigger `channelInactive(ctx:)`.
                channels[channelIdentifier]!.close(promise: nil)
            }
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
