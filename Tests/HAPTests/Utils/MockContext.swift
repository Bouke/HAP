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
}
