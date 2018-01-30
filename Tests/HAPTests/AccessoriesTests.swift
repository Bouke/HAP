// swiftlint:disable force_try
@testable import HAP
import XCTest

class AccessoriesTests: XCTestCase {
    func testSerialize() {
        serialize(Accessory.Door(info: .init(name: "Door", serialNumber: "00021")))
        serialize(Accessory.Fan(info: .init(name: "Fan", serialNumber: "00022")))
        serialize(Accessory.GarageDoorOpener(info: .init(name: "GarageDoorOpener", serialNumber: "00023")))
        serialize(Accessory.Lightbulb(info: .init(name: "Lightbulb", serialNumber: "00024")))
        serialize(Accessory.LockMechanism(info: .init(name: "LockMechanism", serialNumber: "00025")))
        serialize(Accessory.Outlet(info: .init(name: "Outlet", serialNumber: "00026")))
        serialize(Accessory.SecuritySystem(info: .init(name: "SecuritySystem", serialNumber: "00027")))
        serialize(Accessory.Switch(info: .init(name: "Switch", serialNumber: "00028")))
        serialize(Accessory.Thermometer(info: .init(name: "Thermometer", serialNumber: "00029")))
        serialize(Accessory.Thermostat(info: .init(name: "Thermostat", serialNumber: "00030")))
        serialize(Accessory.Window(info: .init(name: "Window", serialNumber: "00031")))
        serialize(Accessory.WindowCovering(info: .init(name: "WindowCovering", serialNumber: "00032")))
    }
}

func serialize(_ accessory: Accessory, file: StaticString = #file, line: UInt = #line) {
    let jsonObject = accessory.serialized()
    XCTAssertTrue(JSONSerialization.isValidJSONObject(jsonObject), "Not a valid JSON object", file: file, line: line)
    _ = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
}
