// swiftlint:disable force_try line_length
@testable import HAP
import NIO
import XCTest

private final class ReadRecorder: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer

    public var reads: [ByteBuffer] = []

    func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        self.reads.append(self.unwrapInboundIn(data))
    }
}

private final class WriteRecorder: ChannelOutboundHandler {
    typealias OutboundIn = ByteBuffer

    public var writes: [ByteBuffer] = []

    func write(ctx: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        self.writes.append(self.unwrapOutboundIn(data))
    }
}

class CryptographerTests: XCTestCase {
    static var allTests: [(String, (CryptographerTests) -> () throws -> Void)] {
        return [
            ("testReadSimpleFrame", testReadSimpleFrame),
            ("testReadMultipleFramesSingleRead", testReadMultipleFramesSingleRead),
            ("testReadPartialFramesMultipleReads", testReadPartialFramesMultipleReads),
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
    fileprivate var readRecorder: ReadRecorder! = nil
    fileprivate var writeRecorder: WriteRecorder! = nil

    override func setUp() {
        channel = EmbeddedChannel()
        readRecorder = ReadRecorder()
        writeRecorder = WriteRecorder()
        handler = CryptographerHandler()
        handler.cryptographer = Cryptographer(sharedKey: sharedKey)
        XCTAssertNoThrow(try channel.pipeline.add(handler: writeRecorder).wait())
        XCTAssertNoThrow(try channel.pipeline.add(handler: handler).wait())
        XCTAssertNoThrow(try channel.pipeline.add(handler: readRecorder).wait())
        context = try! channel.pipeline.context(handler: handler).wait()
    }

    func testReadSimpleFrame() {
        var encryptedBuffer = channel.allocator.buffer(capacity: 31)
        encryptedBuffer.write(bytes: Data(hex: "0d0086707542af59d8a62123455257e9f45b349501f46cad0e5f6ded6aab98")!)
        handler.channelRead(ctx: context, data: NIOAny(encryptedBuffer))

        var buf = readRecorder!.reads[0]
        print(buf)
        print(buf.readableBytes)
        var data = buf.readData(length: buf.readableBytes)!
        print(data.hex)

        var plaintextBuffer = channel.allocator.buffer(capacity: 13)
        plaintextBuffer.write(string: "Hello, world!")
        XCTAssertEqual(readRecorder.reads,
                       [plaintextBuffer])
    }

    func testReadMultipleFramesSingleRead() {
        var encryptedBuffer = channel.allocator.buffer(capacity: 93)
        encryptedBuffer.write(bytes: Data(hex: "0d0086707542af59d8a62123455257e9f45b349501f46cad0e5f6ded6aab98")!)
        encryptedBuffer.write(bytes: Data(hex: "0d008b0d47a5c7e28b261015018c275ea42388d7284df1bb0737bcc7b5b5f5")!)
        encryptedBuffer.write(bytes: Data(hex: "0d0008557d6198431e6121f10b8f9739009732201c917d67c9b05355bcb733")!)
        handler.channelRead(ctx: context, data: NIOAny(encryptedBuffer))

        var plaintextBuffer = channel.allocator.buffer(capacity: 39)
        plaintextBuffer.write(string: "Hello, world!")
        XCTAssertEqual(readRecorder.reads,
                       [plaintextBuffer, plaintextBuffer, plaintextBuffer])
    }

    func testReadPartialFramesMultipleReads() {
        var encryptedBufferFirst = channel.allocator.buffer(capacity: 1)
        encryptedBufferFirst.write(bytes: Data(hex: "0d00")!)
        handler.channelRead(ctx: context, data: NIOAny(encryptedBufferFirst))

        XCTAssertEqual(readRecorder.reads, [])

        var encryptedBufferLast = channel.allocator.buffer(capacity: 30)
        encryptedBufferLast.write(bytes: Data(hex: "86707542af59d8a62123455257e9f45b349501f46cad0e5f6ded6aab98")!)
        handler.channelRead(ctx: context, data: NIOAny(encryptedBufferLast))

        var plaintextBuffer = channel.allocator.buffer(capacity: 13)
        plaintextBuffer.write(string: "Hello, world!")
        XCTAssertEqual(readRecorder.reads,
                       [plaintextBuffer])
    }

    func testWriteSingleFrame() {
        var plaintextBuffer = channel.allocator.buffer(capacity: 13)
        plaintextBuffer.write(string: "Hello, world!")
        handler.write(ctx: context, data: NIOAny(plaintextBuffer), promise: nil)

        var expectedBuffer = channel.allocator.buffer(capacity: 31)
        expectedBuffer.write(bytes: Data(hex: "0d0027359e45fd3856d016b501c8558b915d704849af57525276a9f91b789b")!)
        var buf = writeRecorder.writes[0]
        print(buf.readData(length: buf.readableBytes)!.hex)

        XCTAssertEqual(writeRecorder.writes,
                       [expectedBuffer])
    }

    func testWriteMultipleFrames() {
        var buffer = channel.allocator.buffer(capacity: 1536)
        buffer.write(bytes: Data(repeating: 0, count: 1536))
        handler.write(ctx: context, data: NIOAny(buffer), promise: nil)

        var frame0 = channel.allocator.buffer(capacity: 1572)
        frame0.write(bytes: Data(hex: "00046f50f229921476a779c76dac74149f5cbac5e08e7233e867e6208ef0e6879ce552de1711b096000e8e11af8f494c100db68d1f9971fc95bad3fee4b959a75688297a7181ae2a4fcc46ee7377807004cb66a5ba367a697b161202ab1209e46118d4b5821693381480dcd19afe7717215f2ac9ed04e3501743162097f2084d5cfcec28157eebf605fa2d149201609381fd9e089befc7c6b3a58ab6d04dcbf2e447eca5331d1f8ca0c90934ce122c4aeb458cc7dbda50fa2ce23c352c7baf2d082653859e8b1306134bde412b687ddac7e3ab593126603e3db7d9b8cf8f77258cefcd3e0a134852bde4f64c67650fad2e84abd8f959e5bf6b028ff49fa0ff5f8b8965092c9ae32c8ca5721c31f1dce2941c0fd1f7f8ad35d9bc57bdbb99f14410140e04768b2b2e29f71a508139bd8576cd7398652aa1964448da2163bf413c7204188402faf4e945db7b3e33d65e47958809be382a86d55f774630716bfa6fe66ab3367456f4a27ff36b006994e0fffdbf770e33ff00e820457dce26c167586606dba67e2a972ed7a6dae337aca0c6828701b98397b9e176dc5f8638d51a28245259b58b71c1708915641cc6464be6fe38d379da0c3c8f7e77c2cbe500488ea65a1ad1b97ba757bbe665c3e2e7de7301d9c216ffbfa8c6f2247bcba5e23c1b1c3f794c9e946297dc545ab5a6ec2895ca7544134ba93368b1353624b2c700b9721169540a196d54385e5588e7d712bddc2391b7f32f3707dd5e15f4711d71b97daaf09a9cc7f88450e5d2ffec67ac61927671f77a4f6c98fda113b50754467321b0132fbef0f7762630f57e352aa356805d9a93003d2f8e253d316433f4226dd44ea1662d17b4a365ca9a6340278efa5ded5d4c017489a64edd129f4288cc5588a0616a72e5c730ebaf29b84303487ddaea152ac6fe59bbaf862e44bf9729e08793fbbf0fd760ede2128e315e8945a688d711e519ae586d312104fc493fabe3b4117bd770f3d2a3ed0d215d60b752ecf985685c146b71737d231484308485852b41a4c582299014439c5bacb67adab678b62ebb95e2be9321faf119fef8286dafa5bda448663fcc61606d0c2e3477a5a7e73fc07372e1e66c60399d03fd159e20ef32e6812c0389e953b9006f9d28ac2792b3db192c28ecef234e8f8514e681cd0cb6f0d83ba6521bc582ca01c86e7d4ab7b612ced1b682485f6f760d5009f675cc5e45243301c967a70248454c16eaaf736457fb2f228352c5d0c88f0afb148f29d5674578cf3cd78e8a2de316b9f8f870175184f655bfbb28024d281be5138888868ec44e3d292a712906219262cbeb0d0a855c5502f81ba5f7a87986e8e8616a5e520626617eb88bfe63ae75a01926e17f8d02b37540bfdf29da548f5bab962d4858974a431c574fccf1a34f8fe9f299e80a5035d6fbdb922f92885445550697ec3cda931a682b0bba3d7773cef2f7fc")!)
        var frame1 = channel.allocator.buffer(capacity: 1572)
        frame1.write(bytes: Data(hex: "0002e11819fe31522b9aed04d4c8c1f335744068e3354315c27462eefda696a506a42f9a8379516b42f9c22c340215d481fa81208e186d38d6c4ff8f12e1d5e820aba190bc8f6c51b733ea62c8137513bf9bb8aa7ec13f5863074c4543e38c738ac23da70122327df4cc020ceafcdc0060d78b029f04392199f94d84e9d178d1ccebc4b18748b7fc4419de1743c1f3a4ea23d738cdb5011420682bf6b3f84c502c7a79e1ba99e871b20a8d807552c9a5e6562675257061a6da529ecf023af5a3f25b8a41a1d227b36e11e1e2b85af4307175975c1bca4575dee06f4170b91ec4a5542c7cf8c94988739fa6bff05f4eccbc53079cd19c797a83de182650ed40ae89e9d8413a88cf99c13ac7b5c221416a4a5e6cfa1be303456c75147cd1378787bcf4418289d17f1cb8f09d0ecdb89321dd9a4e616c0358e8ac29d653893061cb3d4866d2ddc1e8ea28fb32d809146841efef072c9ef5a56cd07e68b33dbcc971982ae71be0511f157f0bbc54e5ad4542cde5d12db0aaa53b1c380ea92292e86b632a7db1e8861f605304bb3dccc0dfd51c93f9bcdb7812b42c1ba20c5228ef5a5ed6c970e8a90304ba5e1436043bf54f38a3ebdf5aba58df147eef1af9c34123996fad1877bd9a6ffd95f183a31c1eafd65a00f806bd146dbf4d5cd00cee7c412ad627375bf7bdf5077a71f19bc9222b692448497f107b14b042e4d7da736a100fe5be173e28904ff1b88498cbf7e816c41b")!)
        XCTAssertEqual(writeRecorder.writes,
                       [frame0, frame1])
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
