// swiftlint:disable force_try
import Foundation
import HAP
import XCTest

class StorageTests: XCTestCase {
    static var allTests: [(String, (StorageTests) -> () throws -> Void)] {
        return [
            ("testFileStorage", testFileStorage)
        ]
    }

    func testFileStorage() {
        let storage = FileStorage(filename: "test.tmp")
        let expected = "hello, world".data(using: .utf8)!
        try! storage.write(expected)
        let actual = try! storage.read()
        XCTAssertEqual(expected, actual)
    }
}
