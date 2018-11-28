import NIO
import NIOHTTP1
import Dispatch
import HTTP

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
