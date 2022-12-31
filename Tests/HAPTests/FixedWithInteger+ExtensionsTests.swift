@testable import HAP
import XCTest

final class FixedWidthIntegerExtensionTests: XCTestCase {
    func testBigEndianBytes() throws {
		XCTAssertEqual(UInt8(1).bigEndianBytes, Data([1]))
		XCTAssertEqual(UInt16(1).bigEndianBytes, Data([0, 1]))
		XCTAssertEqual(UInt32(1).bigEndianBytes, Data([0, 0, 0, 1]))
		XCTAssertEqual(UInt64(1).bigEndianBytes, Data([0, 0, 0, 0, 0, 0, 0, 1]))
		XCTAssertEqual(UInt16(1 << 8).bigEndianBytes, Data([1, 0]))
		XCTAssertEqual(UInt32(1 << 24).bigEndianBytes, Data([1, 0, 0, 0]))
		XCTAssertEqual(UInt64(1 << 56).bigEndianBytes, Data([1, 0, 0, 0, 0, 0, 0, 0]))
    }

	func testLittleEndianBytes() throws {
		XCTAssertEqual(UInt8(1).littleEndianBytes, Data([1]))
		XCTAssertEqual(UInt16(1).littleEndianBytes, Data([1, 0]))
		XCTAssertEqual(UInt32(1).littleEndianBytes, Data([1, 0, 0, 0]))
		XCTAssertEqual(UInt64(1).littleEndianBytes, Data([1, 0, 0, 0, 0, 0, 0, 0]))
		XCTAssertEqual(UInt16(1 << 8).littleEndianBytes, Data([0, 1]))
		XCTAssertEqual(UInt32(1 << 24).littleEndianBytes, Data([0, 0, 0, 1]))
		XCTAssertEqual(UInt64(1 << 56).littleEndianBytes, Data([0, 0, 0, 0, 0, 0, 0, 1]))
	}

	func testBE() throws {
		try XCTSkipUnless(UInt(16) == UInt(16).bigEndian, "Platform is LE")
	}

	func testLE() throws {
		try XCTSkipIf(UInt(16) == UInt(16).bigEndian, "Platform is BE")
	}
}
