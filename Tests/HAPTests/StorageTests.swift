// swiftlint:disable force_try
import Foundation
import HAP
import XCTest

class StorageTests: XCTestCase {
    func testFileStorage() {
        let storage = FileStorage(filename: "test.tmp")
        let expected = "hello, world".data(using: .utf8)!
        try! storage.write(expected)
        let actual = try! storage.read()
        XCTAssertEqual(expected, actual)
        try? FileManager.default.removeItem(atPath: "test.tmp")
    }
}
