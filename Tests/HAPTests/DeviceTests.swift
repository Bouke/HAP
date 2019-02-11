import Foundation
@testable import HAP
import XCTest

class DeviceTests: XCTestCase {
    static var allTests: [(String, (DeviceTests) -> () throws -> Void)] {
        return [
            ("testInstanceIdentifiers", testInstanceIdentifiers),
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
        ]
    }

    func testInstanceIdentifiers() {
        // no bridge -- 1 accessory
        do {
            let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00041"),
                                           type: .color,
                                           isDimmable: true)
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
            let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00042"),
                                           type: .color,
                                           isDimmable: true)
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
            let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00044"),
                                           type: .color,
                                           isDimmable: true)
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

    // from: https://oleb.net/blog/2017/03/keeping-xctest-in-sync/#appendix-code-generation-with-sourcery
    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let thisClass = type(of: self)
            let linuxCount = thisClass.allTests.count
            let darwinCount = Int(thisClass
                .defaultTestSuite.testCaseCount)
            XCTAssertEqual(linuxCount,
                           darwinCount,
                           "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
