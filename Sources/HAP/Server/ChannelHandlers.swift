import NIO
import NIOHTTP1
import Dispatch
import HTTP
import Foundation

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
            print("did set cryptographer!")
            cryptographer = Cryptographer(sharedKey: sharedKey)
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
            print("written with cryptographer")
            var buffer = unwrapOutboundIn(data)
            let data = buffer.readData(length: buffer.readableBytes)!
            let encrypted = try! cryptographer.encrypt(data)
            var out = ctx.channel.allocator.buffer(capacity: encrypted.count)
            out.write(bytes: encrypted)
            ctx.fireChannelRead(wrapOutboundOut(out))
        } else {
            ctx.write(data, promise: promise)
        }
    }
}

class ControllerHandler : ChannelInboundHandler {
    typealias InboundIn = HTTPServerRequestPart

    // All access to channels is guarded by channelsSyncQueue.
    private let channelsSyncQueue = DispatchQueue(label: "channelsQueue")
    private var channels: [ObjectIdentifier: Channel] = [:]

    func channelActive(ctx: ChannelHandlerContext) {
        let channel = ctx.channel
        channelsSyncQueue.async {
            self.channels[ObjectIdentifier(channel)] = channel
        }
    }

    func channelInactive(ctx: ChannelHandlerContext) {
        let channel = ctx.channel
        channelsSyncQueue.async {
            self.channels.removeValue(forKey: ObjectIdentifier(channel))
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
            print(response)
            print(response.headers)
            print(response.body.data?.base64EncodedString())
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

