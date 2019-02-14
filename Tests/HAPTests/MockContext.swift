// swiftlint:disable line_length
import Foundation
@testable import HAP
import HTTP
import NIO

class MockContext: RequestContext {
    init() {
        channel = EmbeddedChannel(handler: nil, loop: EmbeddedEventLoop())
        events = []
    }

    var channel: Channel
    var events: [Any]

    func triggerUserOutboundEvent(_ event: Any, promise: EventLoopPromise<Void>?) {
        events.append(event)
    }
}
