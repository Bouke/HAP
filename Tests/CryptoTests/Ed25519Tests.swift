@testable import Crypto
import XCTest

class Ed25519Tests: XCTestCase {
    static var allTests: [(String, (Ed25519Tests) -> () throws -> Void)] {
        return [
            ("testRoundtrip", testRoundtrip),
        ]
    }

    func testRoundtrip() {
        let key = Curve25519.Signing.PrivateKey()
        let key2 = try! Curve25519.Signing.PrivateKey(rawRepresentation: key.rawRepresentation)
        XCTAssertEqual(key.key, key2.key)
        XCTAssertEqual(key.publicKey.key, key2.publicKey.key)
    }
}
