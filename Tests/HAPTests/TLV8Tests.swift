// swiftlint:disable force_try
@testable import HAP
import HKDF
import SRP
import XCTest

class TLV8Tests: XCTestCase {
    static var allTests: [(String, (TLV8Tests) -> () throws -> Void)] {
        return [
            ("test", test),
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
        ]
    }

    func test() {
        let publicKey = Data(repeating: 0, count: 256) + Data(repeating: 1, count: 256) + Data(repeating: 2, count: 256)
        let original: PairTagTLV8 = [
            (.publicKey, publicKey)
        ]
        let encoded = encode(original)
        let decoded: PairTagTLV8 = try! decode(encoded)
        XCTAssertTrue(original == decoded)
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
