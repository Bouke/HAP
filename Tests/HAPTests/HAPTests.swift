import XCTest
import class CryptoSwift.Poly1305
@testable import HAP

class HAPTests: XCTestCase {
    func testCryptoSwiftPoly1305() throws {
        // see https://github.com/krzyzanowskim/CryptoSwift/issues/304
        let poly = Poly1305(key: Array(Data(hex: "1fbee66758ef41f2e0c5c338fee4c6281244e55484d360f11aa0202eec2a4e09")!))
        let actual = Data(poly!.authenticate(Array(Data(hex: "a800ab7faf90ffa83a889fb690db37b5f9e2d51c25a2bbc2c52b01264333d43022564aac46075deaaf4ac7852ebabf0c0ab99cdb486259afdc078ce431498cbdedf7fb4b92aabe49f121fd4650d5f39690364101d6a310e9e67135a63c06e1d4010b08b3be3c034ae6042092bcbed6fb2451005b93f01a4965663635f51a6e37567ddac5135d445342d2bc49277f238e66d651cebcc6cfd4802022738d932e495d457dc5bc23634ff86a9187a102a3491041200a3dbb16d79889")!))!)
        let expected = Data(hex: "9187a102a3491041200a3dbb16d79889")!
        XCTAssertEqual(actual, expected)
    }
}
