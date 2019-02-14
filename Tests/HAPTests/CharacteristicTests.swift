// swiftlint:disable force_try
@testable import HAP
import XCTest

class CharacteristicTests: XCTestCase {
    static var allTests: [(String, (CharacteristicTests) -> () throws -> Void)] {
        return [
            ("testReadOptionalValueType", testReadOptionalValueType),
            ("testWriteOptionalValueType", testWriteOptionalValueType),
            ("testReadWriteOptionalValueType", testReadWriteOptionalValueType)
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

    func testInitFloatValueType() {
        // This used to trap, as `value` would be a `Float` and `minValue` a `Double`, and
        // `Double(Float(0.0001)) < Double(0.0001)`, so: the initial value would be smaller
        // than the minimum value.
        let characteristic = GenericCharacteristic<Float>(type: .batteryLevel, value: 0.0001, minValue: 0.0001)
        XCTAssertEqual(characteristic.value, 0.0001)
    }

    func testValueClippingToBounds() {
        // clip to bounds using `init()`
        let characteristic = GenericCharacteristic<Float>(type: .batteryLevel, value: 2, maxValue: 1, minValue: 0)
        XCTAssertEqual(characteristic.value, 1)

        // clip to bounds using `value.setter`
        characteristic.value = -1
        XCTAssertEqual(characteristic.value, 0)

        // clip to bounds using `setValue`
        try! characteristic.setValue(2, fromChannel: nil)
        XCTAssertEqual(characteristic.value, 1)
    }
}
