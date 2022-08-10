import Foundation
@testable import HAP
import HTTP
import NIO

class MockContext: RequestContext {
    init() { }

    let channel: Channel = EmbeddedChannel(handler: nil, loop: EmbeddedEventLoop())
    var events: [Any] = []
    let session = SessionHandler()

    func triggerUserOutboundEvent(_ event: Any, promise: EventLoopPromise<Void>?) {
        events.append(event)
    }
}
