import Foundation
@testable import HAP
@testable import KituraNet
import XCTest

class DeviceTests: XCTestCase {
    func testInstanceIdentifiers() {
        // no bridge -- 1 accessory
        do {
            let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00041"))
            let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
            let accessories = device.accessories
            let services = accessories.flatMap({ $0.services })
            let characteristics = services.flatMap({ $0.characteristics })
            XCTAssertEqual(accessories.map({ $0.aid }), [1])
            XCTAssertEqual(services.map({ $0.iid }), [1, 8])
            XCTAssertEqual(services.first(where: { $0.type == .info })?.iid, 1)
            XCTAssertEqual(characteristics.map({ $0.iid }),
                           [2, 3, 4, 5, 6, 7, 9, 10, 11, 12])
        }

        // bridge with 1 accessory
        do {
            let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00042"))
            let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
            let accessories = device.accessories
            let services = accessories.flatMap({ $0.services })
            let characteristics = services.flatMap({ $0.characteristics })
            XCTAssertEqual(accessories.map({ $0.aid }), [1])
            XCTAssertEqual(services.map({ $0.iid }), [1, 8])
            XCTAssertEqual(services.first(where: { $0.type == .info })?.iid, 1)
            XCTAssertEqual(characteristics.map({ $0.iid }),
                           [2, 3, 4, 5, 6, 7, 9, 10, 11, 12])
        }

        do {
            let thermostat = Accessory.Thermostat(info: .init(name: "Living room thermostat", serialNumber: "00043"))
            let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00044"))
            let device = Device(bridgeInfo: .init(name: "Test", serialNumber: "00045"),
                                setupCode: "123-44-321",
                                storage: MemoryStorage(),
                                accessories: [thermostat, lamp])
            let accessories = device.accessories
            let services = accessories.flatMap({ $0.services })
            let characteristics = services.flatMap({ $0.characteristics })
            XCTAssertEqual(accessories.map({ $0.aid }), [1, 2, 3])
            XCTAssertEqual(services.map({ $0.iid }), [1, 1, 8, 1, 8])
            XCTAssertEqual(services.filter({ $0.type == .info }).map({ $0.iid }), [1, 1, 1])
            XCTAssertEqual(characteristics.map({ $0.iid }),
                           [2, 3, 4, 5, 6, 7, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12])
        }
    }
}
