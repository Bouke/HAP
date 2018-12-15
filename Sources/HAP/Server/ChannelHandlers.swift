import func Evergreen.getLogger
import NIO
import NIOHTTP1
import Dispatch
import HTTP
import Foundation

fileprivate let logger = getLogger("hap.nio")

enum CryptographyEvent {
    case sharedKey(Data)
}

// TODO: use "cumulationBuffer" (similar to HTTPDecoder) and buffer until
// correct amount of bytes is received.
// TODO: merge with actual cryptographer.
class CryptographerHandler : ChannelDuplexHandler {
    typealias InboundIn = ByteBuffer
    typealias InboundOut = ByteBuffer
    typealias OutboundIn = ByteBuffer
    typealias OutboundOut = ByteBuffer

    var cryptographer: Cryptographer? = nil

    func triggerUserOutboundEvent(ctx: ChannelHandlerContext, event: Any, promise: EventLoopPromise<Void>?) {
        if case let CryptographyEvent.sharedKey(sharedKey) = event {
            cryptographer = Cryptographer(sharedKey: sharedKey)
            promise?.succeed(result: ())
        } else {
            ctx.triggerUserOutboundEvent(event, promise: promise)
        }
    }

    func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        if let cryptographer = cryptographer {
            var buffer = unwrapInboundIn(data)
            let data = buffer.readData(length: buffer.readableBytes)!
            let decrypted = try! cryptographer.decrypt(data)
            var out = ctx.channel.allocator.buffer(capacity: decrypted.count)
            out.write(bytes: decrypted)
            ctx.fireChannelRead(wrapInboundOut(out))
        } else {
            ctx.fireChannelRead(data)
        }
    }

    func write(ctx: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        if let cryptographer = cryptographer {
            var buffer = unwrapOutboundIn(data)
            let data = buffer.readData(length: buffer.readableBytes)!
            let encrypted = try! cryptographer.encrypt(data)
            var out = ctx.channel.allocator.buffer(capacity: encrypted.count)
            out.write(bytes: encrypted)
            ctx.write(wrapOutboundOut(out), promise: promise)
        } else {
            ctx.write(data, promise: promise)
        }
    }
}

class EventHandler : ChannelOutboundHandler {
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

        let event = try! Event(valueChangedOfCharacteristics: pendingNotifications)
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

class ControllerHandler : ChannelDuplexHandler {
    typealias InboundIn = HTTPServerRequestPart
    typealias OutboundIn = HTTPServerResponsePart

    // All access to channels is guarded by channelsSyncQueue.
    private let channelsSyncQueue = DispatchQueue(label: "channelsQueue")
    private var channels: [ObjectIdentifier: Channel] = [:]
    private var pairings: [ObjectIdentifier: Pairing] = [:]

    internal var removeSubscriptions: ((Channel) -> ())? = nil

    func channelActive(ctx: ChannelHandlerContext) {
        let channel = ctx.channel
        channelsSyncQueue.async {
            self.channels[ObjectIdentifier(channel)] = channel
        }
    }

    func channelInactive(ctx: ChannelHandlerContext) {
        let channel = ctx.channel
        channelsSyncQueue.async {
            // TODO: remove subscriber from device as well!
            self.channels.removeValue(forKey: ObjectIdentifier(channel))
            self.pairings.removeValue(forKey: ObjectIdentifier(channel))
            self.removeSubscriptions?(channel)
        }
    }

    func triggerUserOutboundEvent(ctx: ChannelHandlerContext, event: Any, promise: EventLoopPromise<Void>?) {
        if case let PairingEvent.verified(pairing) = event {
            let channel = ctx.channel
            channelsSyncQueue.async {
                self.pairings[ObjectIdentifier(channel)] = pairing
            }
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
        channelsSyncQueue.async {
            guard let channel = self.channels[identifier] else {
                // todo... probably need to clean up?
                logger.error("event for non-existing channel")
                return
            }
            channel.triggerUserOutboundEvent(CharacteristicEvent.changed(characteristic), promise: nil)
        }
    }
}

typealias Responder = (ChannelHandlerContext, HTTPRequest) -> HTTPResponse

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
