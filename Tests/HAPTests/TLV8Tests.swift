// swiftlint:disable force_try
@testable import HAP
import SRP
import XCTest

class TLV8Tests: XCTestCase {
    func test() {
        let publicKey = Data(repeating: 0, count: 256) + Data(repeating: 1, count: 256) + Data(repeating: 2, count: 256)
        let original: PairTagTLV8 = [
            (.publicKey, publicKey)
        ]
        let encoded = encode(original)
        let decoded: PairTagTLV8 = try! decode(encoded)
        XCTAssertTrue(original == decoded)
    }
}
