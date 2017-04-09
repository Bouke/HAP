import Foundation
@testable import HAP
@testable import KituraNet
import XCTest

class EndpointTests: XCTestCase {
    static var allTests : [(String, (EndpointTests) -> () throws -> Void)] {
        return [
            ("testAccessories", testAccessories),
            ("testCharacteristics", testCharacteristics),
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
        ]
    }
    
    func testAccessories() {
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left"))
        let device = Device(name: "Test", pin: "123-44-321", storage: MemoryStorage(), accessories: [lamp])
        let application = accessories(device: device)
        let response = application(MockConnection(), MockRequest.get(path: "/accessories"))
        let jsonObject = try! JSONSerialization.jsonObject(with: response.body!, options: []) as! [String: [[String: Any]]]
        guard let accessory = jsonObject["accessories"]?.first else {
            return XCTFail("No accessory")
        }
        XCTAssertEqual(accessory["aid"] as? Int, 1)
        guard let services = accessory["services"] as? [[String: Any]] else {
            return XCTFail("No services")
        }
        
        guard let metaService = services.first(where: { ($0["type"] as? String) == "3E" }) else {
            return XCTFail("No meta")
        }
        XCTAssertEqual(metaService["iid"] as? Int, 1)
        XCTAssertEqual((metaService["characteristics"] as? [Any])?.count, 5)
        
        guard let lampService = services.first(where: { ($0["type"] as? String) == "43" }) else {
            return XCTFail("No lamp")
        }
        XCTAssertEqual(lampService["iid"] as? Int, 7)
        XCTAssertEqual((lampService["characteristics"] as? [Any])?.count, 4)
    }

    
    /// This test assumes that 1.3 and 1.5 are respectively `manufacturer` and
    /// `name`. This does not need to be the case.
    func testCharacteristics() {
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", manufacturer: "Bouke"))
        let device = Device(name: "Test", pin: "123-44-321", storage: MemoryStorage(), accessories: [lamp])
        let application = characteristics(device: device)
        let response = application(MockConnection(), MockRequest.get(path: "/characteristics?id=1.3,1.5"))
        guard let jsonObject = (try? JSONSerialization.jsonObject(with: response.body!, options: [])) as? [String: [[String: Any]]] else {
            return XCTFail("Could not decode")
        }
        guard let characteristics = jsonObject["characteristics"] else {
            return XCTFail("No characteristics")
        }
        guard let manufacturerCharacteristic = characteristics.first(where: { $0["iid"] as? Int == 3 }) else {
            return XCTFail("No manufacturer")
        }
        XCTAssertEqual(manufacturerCharacteristic["value"] as? String, "Bouke")
        guard let nameCharacteristic = characteristics.first(where: { $0["iid"] as? Int == 5 }) else {
            return XCTFail("No name")
        }
        XCTAssertEqual(nameCharacteristic["value"] as? String, "Night stand left")
    }

    // from: https://oleb.net/blog/2017/03/keeping-xctest-in-sync/#appendix-code-generation-with-sourcery
    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let thisClass = type(of: self)
            let linuxCount = thisClass.allTests.count
            let darwinCount = Int(thisClass
                .defaultTestSuite().testCaseCount)
            XCTAssertEqual(linuxCount, darwinCount,
                           "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
