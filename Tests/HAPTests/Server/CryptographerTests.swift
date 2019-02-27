// swiftlint:disable force_try
@testable import HAP
import NIO
import XCTest

class CryptographerTests: XCTestCase {
    static var allTests: [(String, (CryptographerTests) -> () throws -> Void)] {
        return [
            ("testReadSimpleFrame", testReadSimpleFrame),
            ("testReadPartialFrames", testReadPartialFrames),
            ("testWriteSingleFrame", testWriteSingleFrame),
            ("testWriteMultipleFrames", testWriteMultipleFrames),
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
        ]
    }

    var channel: EmbeddedChannel!
    var eventLoop: EmbeddedEventLoop!
    var context: ChannelHandlerContext!
    var handler: CryptographerHandler!
    var sharedKey = Data(repeating: 0, count: 32)

    override func setUp() {
        eventLoop = EmbeddedEventLoop()
        channel = EmbeddedChannel(handler: nil, loop: eventLoop)
        handler = CryptographerHandler()
        handler.cryptographer = Cryptographer(sharedKey: sharedKey)
        try! channel.pipeline.add(handler: handler).wait()
        context = try! channel.pipeline.context(handler: handler).wait()
    }

    func testReadSimpleFrame() {
        XCTFail("Not implemented")
    }

    func testReadPartialFrames() {
        var buffer = channel.allocator.buffer(capacity: 0)
        handler.channelRead(ctx: context, data: NIOAny(buffer))
        XCTFail("Not implemented")
    }

    func testWriteSingleFrame() {
        var buffer = channel.allocator.buffer(capacity: 12)
        buffer.write(string: "Hello, world!")
        handler.write(ctx: context, data: NIOAny(buffer), promise: nil)
        //TODO: assert!
        XCTFail("No assertions")
    }

    func testWriteMultipleFrames() {
        var buffer = channel.allocator.buffer(capacity: 1536)
        // need to fill the buffer?
        handler.write(ctx: context, data: NIOAny(buffer), promise: nil)
        //TODO: assert!
        XCTFail("No assertions")
    }

    // from: https://oleb.net/blog/2017/03/keeping-xctest-in-sync/#appendix-code-generation-with-sourcery
    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        let thisClass = type(of: self)
        let linuxCount = thisClass.allTests.count
        let darwinCount = Int(thisClass
            .defaultTestSuite.testCaseCount)
        XCTAssertEqual(linuxCount,
                       darwinCount,
                       "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
