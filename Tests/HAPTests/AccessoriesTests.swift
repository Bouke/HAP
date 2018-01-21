// swiftlint:disable force_try
@testable import HAP
import XCTest

class AccessoriesTests: XCTestCase {
    func testSerialize() {
        serialize(Accessory.Door(info: .init(name: "Door")))
        serialize(Accessory.Fan(info: .init(name: "Fan")))
        serialize(Accessory.GarageDoorOpener(info: .init(name: "GarageDoorOpener")))
        serialize(Accessory.Lightbulb(info: .init(name: "Lightbulb")))
        serialize(Accessory.LockMechanism(info: .init(name: "LockMechanism")))
        serialize(Accessory.Outlet(info: .init(name: "Outlet")))
        serialize(Accessory.SecuritySystem(info: .init(name: "SecuritySystem")))
        serialize(Accessory.Switch(info: .init(name: "Switch")))
        serialize(Accessory.Thermometer(info: .init(name: "Thermometer")))
        serialize(Accessory.Thermostat(info: .init(name: "Thermostat")))
        serialize(Accessory.Window(info: .init(name: "Window")))
        serialize(Accessory.WindowCovering(info: .init(name: "WindowCovering")))
    }
}

func serialize(_ accessory: Accessory, file: StaticString = #file, line: UInt = #line) {
    let jsonObject = accessory.serialized()
    XCTAssertTrue(JSONSerialization.isValidJSONObject(jsonObject), "Not a valid JSON object", file: file, line: line)
    _ = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
}
