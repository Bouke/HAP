@testable import HAP
import XCTest

class CharacteristicTests: XCTestCase {
    static var allTests: [(String, (CharacteristicTests) -> () throws -> Void)] {
        return [
            ("testReadOptionalValueType", testReadOptionalValueType),
            ("testWriteOptionalValueType", testWriteOptionalValueType),
            ("testReadWriteOptionalValueType", testReadWriteOptionalValueType),
        ]
    }

    func testReadOptionalValueType() {
        let characteristic = GenericCharacteristic<Bool?>(type: .identify, value: false)
        guard let value = characteristic.getValue() as? Bool? else {
            XCTFail("Could not get value")
            return
        }
        XCTAssert(value == false)
    }

    func testWriteOptionalValueType() {
        let characteristic = GenericCharacteristic<Bool?>(type: .identify, permissions: [.write])
        do {
            try characteristic.setValue(true, fromChannel: nil)
        } catch {
            XCTFail("Could not set value: \(error)")
        }
    }

    func testReadWriteOptionalValueType() {
        let characteristic = GenericCharacteristic<Bool?>(type: .identify, value: false)
        do {
            try characteristic.setValue(true, fromChannel: nil)
        } catch {
            XCTFail("Could not set value: \(error)")
        }
        guard let value = characteristic.getValue() as? Bool? else {
            XCTFail("Could not get value")
            return
        }
        XCTAssertTrue(value == true)
    }
}
