// swiftlint:disable force_try force_cast
import Foundation
@testable import HAP
import NIO
import VaporHTTP

class MockContext: RequestContext {
    init() { }

    let channel: Channel = EmbeddedChannel(handler: nil, loop: EmbeddedEventLoop())
    var events: [Any] = []
    let session = SessionHandler()

    func triggerUserOutboundEvent(_ event: Any, promise: EventLoopPromise<Void>?) {
        events.append(event)
    }

    func call(_ responder: Responder, _ request: HTTPRequest) -> HTTPResponse {
        let future = responder(self, request)
        let eventLoop = self.channel.eventLoop as! EmbeddedEventLoop
        eventLoop.run()
        return try! future.wait()
    }
}
