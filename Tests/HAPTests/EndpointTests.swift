// swiftlint:disable cyclomatic_complexity force_cast force_try type_body_length file_length line_length
import Foundation
@testable import HAP
import HTTP
import NIO
import XCTest

class EndpointTests: XCTestCase {
    static var allTests: [(String, (EndpointTests) -> () throws -> Void)] {
        #if os(macOS)
            let asynchronousTests: [(String, (EndpointTests) -> () throws -> Void)] = [
                ("testNoEventsToSelf", testNoEventsToSelf),
                ("testSingleEventPerUpdate", testSingleEventPerUpdate),
                ("testDelayMultipleEvents", testDelayMultipleEvents),
                ("testDelayMultipleEventsCoalescence", testDelayMultipleEventsCoalescence),
                ("testDelayMultipleEventsCoalescenceFiltering", testDelayMultipleEventsCoalescenceFiltering)
            ]
        #else
            let asynchronousTests: [(String, (EndpointTests) -> () throws -> Void)] = []
        #endif

        return [
            ("testAccessories", testAccessories),
            ("testCustomCharacteristicType", testCustomCharacteristicType),
            ("testGetCharacteristics", testGetCharacteristics),
            ("testPutBoolAndIntCharacteristics", testPutBoolAndIntCharacteristics),
            ("testPutDoubleAndEnumCharacteristics", testPutDoubleAndEnumCharacteristics),
            ("testPutBadCharacteristics", testPutBadCharacteristics),
            ("testGetBadCharacteristics", testGetBadCharacteristics),
            ("testAuthentication", testAuthentication),
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
        ] + asynchronousTests
    }

    func testAccessories() {
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00055"), type: .color, isDimmable: true)
        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
        let application = accessories(device: device)
        let response = application(MockContext(), HTTPRequest(uri: "/accessories"))
        let jsonObject = try! JSONSerialization.jsonObject(with: response.body.data ?? Data(), options: []) as! [String: [[String: Any]]]
        guard let accessory = jsonObject["accessories"]?.first else {
            return XCTFail("No accessory")
        }
        XCTAssertEqual(accessory["aid"] as? Int, lamp.aid)
        guard let services = accessory["services"] as? [[String: Any]] else {
            return XCTFail("No services")
        }

        guard let metaService = services.first(where: { ($0["type"] as? String) == "3E" }) else {
            return XCTFail("No meta")
        }
        XCTAssertEqual(metaService["iid"] as? Int, 1)
        XCTAssertEqual((metaService["characteristics"] as? [Any])?.count, 6)

        guard let lampService = services.first(where: { ($0["type"] as? String) == "43" }) else {
            return XCTFail("No lamp")
        }
        XCTAssertEqual(lampService["iid"] as? Int, 8)

        guard let lampCharacteristics = lampService["characteristics"] as? [[String: Any]] else {
            return XCTFail("No lamp characteristics")
        }
        XCTAssertEqual(lampCharacteristics.count, 4)
    }

    static let watt = CharacteristicType(UUID(uuidString: "E863F10D-079E-48FF-8F27-9C2605A29F52")!)
    static let kiloWattHour = CharacteristicType(UUID(uuidString: "E863F10C-079E-48FF-8F27-9C2605A29F52")!)

    class Energy: Accessory {
        let service = EnergyService()

        init(info: Service.Info) {
            super.init(info: info, type: .outlet, services: [service])
        }
    }

    class EnergyService: Service {
        let on = GenericCharacteristic<Bool>(type: .powerState, value: false)
        let inUse = GenericCharacteristic<Bool>(type: .outletInUse, value: true, permissions: [.read, .events])
        let watt = GenericCharacteristic<Double>(type: EndpointTests.watt, value: 42, permissions: [.read, .events])
        let kiloWattHour = GenericCharacteristic<Double>(type: EndpointTests.kiloWattHour, value: 0, permissions: [.read, .events])

        init() {
            super.init(type: .outlet, characteristics: [
                AnyCharacteristic(on as Characteristic),
                AnyCharacteristic(inUse as Characteristic),
                AnyCharacteristic(watt as Characteristic),
                AnyCharacteristic(kiloWattHour as Characteristic)])
        }
    }

    func testCustomCharacteristicType() {
        let energy = Energy(info: .init(name: "Energy", serialNumber: "00057"))
        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: energy)
        let application = characteristics(device: device)
        let testQueue = DispatchQueue(label: "TestQueue")
        testQueue.async {
            let response = application(MockContext(), HTTPRequest(uri: "/characteristics?id=\(energy.aid).\(energy.info.name.iid),\(energy.aid).\(energy.service.watt.iid)&meta=1&perms=1&type=1&ev=1"))
            guard let jsonObject = (try? JSONSerialization.jsonObject(with: response.body.data ?? Data(), options: [])) as? [String: [[String: Any]]] else {
                return XCTFail("Could not decode")
            }
            guard let characteristics = jsonObject["characteristics"] else {
                return XCTFail("No characteristics")
            }

            guard let nameCharacteristic = characteristics.first(where: { $0["iid"] as? Int == energy.info.name.iid }) else {
                return XCTFail("No name characteristic")
            }
            XCTAssertEqual(nameCharacteristic["value"] as? String, "Energy")
            XCTAssertEqual(nameCharacteristic["perms"] as? [String] ?? [], ["pr"])
            XCTAssertEqual(nameCharacteristic["type"] as? String, "23")
            XCTAssertEqual(nameCharacteristic["ev"] as? Bool, false)

            guard let wattCharacteristic = characteristics.first(where: { $0["iid"] as? Int == energy.service.watt.iid }) else {
                return XCTFail("No identify characteristic")
            }
            XCTAssertEqual(wattCharacteristic["value"] as? Int, 42)
            XCTAssertEqual(wattCharacteristic["type"] as? String, "E863F10D-079E-48FF-8F27-9C2605A29F52")
        }
        let expectation = self.expectation(description: "Test Complete")
        testQueue.async { expectation.fulfill() }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetCharacteristics() {
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00056", manufacturer: "Bouke"), isDimmable: true)
        lamp.lightbulb.brightness!.value = 100
        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
        let application = characteristics(device: device)
        let testQueue = DispatchQueue(label: "TestQueue")
        testQueue.async {
            let response = application(MockContext(), HTTPRequest(uri: "/characteristics?id=\(lamp.aid).\(lamp.info.manufacturer.iid),\(lamp.aid).\(lamp.info.name.iid)"))
            guard let jsonObject = (try? JSONSerialization.jsonObject(with: response.body.data ?? Data(), options: [])) as? [String: [[String: Any]]] else {
                return XCTFail("Could not decode")
            }
            guard let characteristics = jsonObject["characteristics"] else {
                return XCTFail("No characteristics")
            }

            guard let manufacturerCharacteristic = characteristics.first(where: { $0["iid"] as? Int == lamp.info.manufacturer.iid }) else {
                return XCTFail("No manufacturer characteristic")
            }
            XCTAssertEqual(manufacturerCharacteristic["value"] as? String, "Bouke")

            guard let nameCharacteristic = characteristics.first(where: { $0["iid"] as? Int == lamp.info.name.iid }) else {
                return XCTFail("No name characteristic")
            }
            XCTAssertEqual(nameCharacteristic["value"] as? String, "Night stand left")
        }

        testQueue.async {
            let response = application(MockContext(), HTTPRequest(uri: "/characteristics?id=\(lamp.aid).\(lamp.info.name.iid),\(lamp.aid).\(lamp.lightbulb.brightness!.iid)&meta=1&perms=1&type=1&ev=1"))
            guard let jsonObject = (try? JSONSerialization.jsonObject(with: response.body.data ?? Data(), options: [])) as? [String: [[String: Any]]] else {
                return XCTFail("Could not decode")
            }
            guard let characteristics = jsonObject["characteristics"] else {
                return XCTFail("No characteristics")
            }

            guard let nameCharacteristic = characteristics.first(where: { $0["iid"] as? Int == lamp.info.name.iid }) else {
                return XCTFail("No name characteristic")
            }
            XCTAssertEqual(nameCharacteristic["value"] as? String, "Night stand left")
            XCTAssertEqual(nameCharacteristic["perms"] as? [String] ?? [], ["pr"])
            XCTAssertEqual(nameCharacteristic["type"] as? String, "23")
            XCTAssertEqual(nameCharacteristic["ev"] as? Bool, false)

            guard let brightnessCharacteristic = characteristics.first(where: { $0["iid"] as? Int == lamp.lightbulb.brightness!.iid }) else {
                return XCTFail("No identify characteristic")
            }
            XCTAssertEqual(brightnessCharacteristic["value"] as? Int, 100)
            XCTAssertEqual(brightnessCharacteristic["maxValue"] as? Int, 100)
            XCTAssertEqual(brightnessCharacteristic["minValue"] as? Int, 0)
            XCTAssertEqual(brightnessCharacteristic["minStep"] as? Int, 1)
            XCTAssertEqual(brightnessCharacteristic["unit"] as? String, "percentage")
            XCTAssertEqual(brightnessCharacteristic["perms"] as? [String] ?? [], ["pr", "pw", "ev"])
            XCTAssertEqual(brightnessCharacteristic["type"] as? String, "8")
            XCTAssertEqual(brightnessCharacteristic["ev"] as? Bool, true)
        }
        let expectation = self.expectation(description: "Test Complete")
        testQueue.async { expectation.fulfill() }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testPutBoolAndIntCharacteristics() {
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00057", manufacturer: "Bouke"), isDimmable: true)
        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
        let application = characteristics(device: device)
        let testQueue = DispatchQueue(label: "TestQueue")

        lamp.lightbulb.powerState.value = false
        lamp.lightbulb.brightness?.value = 0

        // turn lamp on
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "iid": lamp.lightbulb.powerState.iid,
                        "value": 1
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(lamp.lightbulb.powerState.value, true)
        }

        // 50% brightness
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "iid": lamp.lightbulb.brightness!.iid,
                        "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(lamp.lightbulb.brightness!.value, 50)
        }

        // 100% brightness
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "iid": lamp.lightbulb.brightness!.iid,
                        "value": Double(100)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(lamp.lightbulb.brightness!.value, 100)
        }
        let expectation = self.expectation(description: "Test Complete")
        testQueue.async { expectation.fulfill() }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testPutDoubleAndEnumCharacteristics() {
        let thermostat = Accessory.Thermostat(info: .init(name: "Thermostat", serialNumber: "00058", manufacturer: "Bouke"))
        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: thermostat)
        let application = characteristics(device: device)
        let testQueue = DispatchQueue(label: "TestQueue")

        thermostat.thermostat.currentHeatingCoolingState.value = .off
        thermostat.thermostat.currentTemperature.value = 18

        thermostat.thermostat.targetHeatingCoolingState.value = .off
        thermostat.thermostat.targetTemperature.value = 15

        // turn up the heat
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.thermostat.targetTemperature.iid,
                        "value": 19.5
                    ],
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.thermostat.targetHeatingCoolingState.iid,
                        "value": Enums.TargetHeatingCoolingState.auto.rawValue
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(thermostat.thermostat.targetTemperature.value, 19.5)
            XCTAssertEqual(thermostat.thermostat.targetHeatingCoolingState.value, .auto)
        }

        // turn up the heat some more (value is an Int on Linux, needs to be cast to Double)
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.thermostat.targetTemperature.iid,
                        "value": 20
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(thermostat.thermostat.targetTemperature.value, 20)
        }

        // turn off
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.thermostat.targetHeatingCoolingState.iid,
                        "value": Enums.TargetHeatingCoolingState.off.rawValue
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(thermostat.thermostat.targetHeatingCoolingState.value, .off)
        }

        // wirting all Apple defined properties
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.thermostat.targetHeatingCoolingState.iid,
                        "value": Enums.TargetHeatingCoolingState.off.rawValue,
                        "ev": true,
                        "authData": "string",
                        "remote": true
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(thermostat.thermostat.targetHeatingCoolingState.value, .off)
        }
        let expectation = self.expectation(description: "Test Complete")
        testQueue.async { expectation.fulfill() }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testPutBadCharacteristics() {
        let thermostat = Accessory.Thermostat(info: .init(name: "Thermostat", serialNumber: "00059"))
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00060"), isDimmable: true)
        let device = Device(bridgeInfo: .init(name: "Test", serialNumber: "00060B"), setupCode: "123-44-321", storage: MemoryStorage(), accessories: [thermostat, lamp])
        let application = characteristics(device: device)
        let testQueue = DispatchQueue(label: "TestQueue")
        // Writing to read only value should not succeed.
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "iid": lamp.info.manufacturer.iid,
                        "value": "value"
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
        }

        // Writing incorrect value should not succeed.
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "iid": lamp.info.identify.iid,
                        "value": "value"
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
            let json = try! JSONSerialization.jsonObject(with: response.body.data ?? Data())  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int, HAPStatusCodes.invalidValue.rawValue)
        }

        // Writing two values, one should fail as it is read only, the other
        // should succeed.
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.info.manufacturer.iid,
                        "value": "value"
                    ],
                    [
                        "aid": lamp.aid,
                        "iid": lamp.lightbulb.brightness!.iid,
                        "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .multiStatus)
            XCTAssertEqual(lamp.lightbulb.brightness!.value, 50)

            let json = try! JSONSerialization.jsonObject(with: response.body.data ?? Data())  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int, HAPStatusCodes.readOnly.rawValue)
            XCTAssertEqual(json["characteristics"]![1]["status"]! as! Int, HAPStatusCodes.success.rawValue)

        }

        // Writing two values, both should fail as the first one is read only
        // and the second receives an invalid value.
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.info.manufacturer.iid,
                        "value": "value"
                    ],
                    [
                        "aid": lamp.aid,
                        "iid": lamp.lightbulb.powerState.iid,
                        "value": "value"
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .multiStatus)

            let json = try! JSONSerialization.jsonObject(with: response.body.data ?? Data())  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int, HAPStatusCodes.readOnly.rawValue)
            XCTAssertEqual(json["characteristics"]![1]["status"]! as! Int, HAPStatusCodes.invalidValue.rawValue)

        }

        // Writing two values, one should succeed and the other should fail as it is read only.
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "iid": lamp.lightbulb.brightness!.iid,
                        "value": Double(50)
                    ],
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.info.firmwareRevision!.iid,
                        "value": "value"
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .multiStatus)
            XCTAssertEqual(lamp.lightbulb.brightness!.value, 50)

            let json = try! JSONSerialization.jsonObject(with: response.body.data ?? Data())  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int, HAPStatusCodes.success.rawValue)
            XCTAssertEqual(json["characteristics"]![1]["status"]! as! Int, HAPStatusCodes.readOnly.rawValue)
        }

        // Writing two values, both should fail as they are read only.
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "iid": lamp.info.serialNumber.iid,
                        "value": "value"
                    ],
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.info.model.iid,
                        "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .multiStatus)
            XCTAssertEqual(lamp.lightbulb.brightness!.value, 50)

            let json = try! JSONSerialization.jsonObject(with: response.body.data ?? Data())  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int, HAPStatusCodes.readOnly.rawValue)
            XCTAssertEqual(json["characteristics"]![1]["status"]! as! Int, HAPStatusCodes.readOnly.rawValue)

        }

        // "400 Bad Request" on HAP client error, e.g. a malformed request
        // at least one of `value` or `ev` should be present.
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "iid": lamp.info.serialNumber.iid
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
        }

        // Leaving out the `iid` field should not succeed.
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
        }

        // Leaving out the `aid` field should not succeed.
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "iid": lamp.info.serialNumber.iid,
                        "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
        }

        // "422 Unprocessable Entity" for a well-formed request that contains
        // invalid parameters.
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": 12,
                        "iid": 3,
                        "value": "value"
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .unprocessableEntity)
        }

        // "422 Unprocessable Entity" for a well-formed request that contains
        // invalid parameters.
        testQueue.async {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": 1,
                        "iid": 33,
                        "value": "value"
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
            XCTAssertEqual(response.status, .unprocessableEntity)
        }
        let expectation = self.expectation(description: "Test Complete")
        testQueue.async { expectation.fulfill() }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetBadCharacteristics() {
        let lightsensor = Accessory.LightSensor(info: .init(name: "LightSensor", serialNumber: "00061"))
        let thermostat = Accessory.Thermostat(info: .init(name: "Thermostat", serialNumber: "00062"))
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00063"), isDimmable: true)

        lightsensor.lightSensor.currentLightLevel.value = 234
        thermostat.thermostat.currentTemperature.value = 100
        lamp.lightbulb.brightness!.value = 53
        let device = Device(bridgeInfo: .init(name: "Test", serialNumber: "00063B"), setupCode: "123-44-321", storage: MemoryStorage(), accessories: [lightsensor, thermostat, lamp])
        let application = characteristics(device: device)
        let testQueue = DispatchQueue(label: "TestQueue")

        // First a good one
        testQueue.async {
            let req = "\(lamp.aid).\(lamp.lightbulb.brightness!.iid),\(lightsensor.aid).\(lightsensor.lightSensor.currentLightLevel.iid),\(thermostat.aid).\(thermostat.thermostat.currentTemperature.iid)"
            let response = application(MockContext(), HTTPRequest(uri: "/characteristics?id=\(req)"))

            XCTAssertEqual(response.status, .ok)

            guard let jsonObject = (try? JSONSerialization.jsonObject(with: response.body.data ?? Data(), options: [])) as? [String: [[String: Any]]] else {
                return XCTFail("Could not decode")
            }
            guard let characteristics = jsonObject["characteristics"] else {
                return XCTFail("No characteristics")
            }

            guard let light = characteristics.first(where: { $0["aid"] as? Int == lightsensor.aid }) else {
                return XCTFail("Could not get light aid")
            }

            guard let therm = characteristics.first(where: { $0["aid"] as? Int == thermostat.aid }) else {
                return XCTFail("Could not get therm aid")
            }

            guard let lampa = characteristics.first(where: { $0["aid"] as? Int == lamp.aid }) else {
                return XCTFail("Could not get lampa aid")
            }

            guard let lightVal = Float(value: light["value"] as Any) else {
                return XCTFail("light is not Double")
            }

            guard let thermVal = Float(value: therm["value"] as Any) else {
                return XCTFail("therm is not Double")
            }

            guard let lampaVal = Int(value: lampa["value"] as Any) else {
                return XCTFail("therm is not Int")
            }

            XCTAssertEqual(lightVal, lightsensor.lightSensor.currentLightLevel.value)
            XCTAssertEqual(thermVal, thermostat.thermostat.currentTemperature.value)
            XCTAssertEqual(lampaVal, lamp.lightbulb.brightness!.value)
        }

        // trying to read write only access
        testQueue.async {
            let iid = lightsensor.info.identify.iid
            let aid = lightsensor.aid
            let response = application(MockContext(), HTTPRequest(uri: "/characteristics?id=\(aid).\(iid)"))
            XCTAssertEqual(response.status, .multiStatus)
            let json = try! JSONSerialization.jsonObject(with: response.body.data ?? Data())  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int, HAPStatusCodes.writeOnly.rawValue)
            XCTAssertEqual(json["characteristics"]![0]["aid"]! as! Int, aid)
            XCTAssertEqual(json["characteristics"]![0]["iid"]! as! Int, iid)
        }

        // trying to read write only access and one with read access
        testQueue.async {
            let iid = lightsensor.info.identify.iid
            let aid = lightsensor.aid
            let iid2 = thermostat.thermostat.currentTemperature.iid
            let aid2 = thermostat.aid
            let response = application(MockContext(), HTTPRequest(uri: "/characteristics?id=\(aid2).\(iid2),\(aid).\(iid)"))
            XCTAssertEqual(response.status, .multiStatus)
            guard let jsonObject = (try? JSONSerialization.jsonObject(with: response.body.data ?? Data(), options: [])) as? [String: [[String: Any]]] else {
                return XCTFail("Could not decode")
            }
            guard let characteristics = jsonObject["characteristics"] else {
                return XCTFail("No characteristics")
            }

            guard let light = characteristics.first(where: { $0["aid"] as! Int == aid }) else {
                return XCTFail("light is missing")
            }
            guard let therm = characteristics.first(where: { $0["aid"] as! Int == aid2 }) else {
                return XCTFail("thermostat is missing")
            }

            XCTAssertNil(light["value"])
            XCTAssertEqual(light["status"] as? Int, HAPStatusCodes.writeOnly.rawValue)
            XCTAssertEqual(therm["status"] as? Int, HAPStatusCodes.success.rawValue)
            XCTAssertEqual(Float(value: therm["value"] as Any), thermostat.thermostat.currentTemperature.value)
        }

        // trying to read write only access and one with read access, reverse order
        testQueue.async {
            let iid = lightsensor.info.identify.iid
            let aid = lightsensor.aid
            let iid2 = thermostat.thermostat.currentTemperature.iid
            let aid2 = thermostat.aid
            let response = application(MockContext(), HTTPRequest(uri: "/characteristics?id=\(aid).\(iid),\(aid2).\(iid2)"))
            XCTAssertEqual(response.status, .multiStatus)
            guard let jsonObject = (try? JSONSerialization.jsonObject(with: response.body.data ?? Data(), options: [])) as? [String: [[String: Any]]] else {
                return XCTFail("Could not decode")
            }
            guard let characteristics = jsonObject["characteristics"] else {
                return XCTFail("No characteristics")
            }

            guard let light = characteristics.first(where: { $0["aid"] as! Int == aid }) else {
                return XCTFail("light is missing")
            }
            guard let therm = characteristics.first(where: { $0["aid"] as! Int == aid2 }) else {
                return XCTFail("thermostat is missing")
            }

            XCTAssertNil(light["value"])
            XCTAssertEqual(light["status"] as? Int, HAPStatusCodes.writeOnly.rawValue)
            XCTAssertEqual(therm["status"] as? Int, HAPStatusCodes.success.rawValue)
            XCTAssertEqual(Float(value: therm["value"] as Any), thermostat.thermostat.currentTemperature.value)
        }
        let expectation = self.expectation(description: "Test Complete")
        testQueue.async { expectation.fulfill() }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testAuthentication() {
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00064"))
        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
        let application = root(device: device)
        do {
            let response = application(MockContext(), HTTPRequest(uri: "/identify"))
            XCTAssertEqual(response.status, .unauthorized)
        }
        do {
            let response = application(MockContext(), HTTPRequest(uri: "/accessories"))
            XCTAssertEqual(response.status, .unauthorized)
        }
        do {
            let response = application(MockContext(), HTTPRequest(uri: "/characteristics"))
            XCTAssertEqual(response.status, .unauthorized)
        }
        do {
            let response = application(MockContext(), HTTPRequest(uri: "/pairings"))
            XCTAssertEqual(response.status, .unauthorized)
        }
    }

    #if os(macOS)
    func testNoEventsToSelf() {
//        let thermostat = Accessory.Thermostat(info: .init(name: "Thermostat", serialNumber: "00065"))
//        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00066"))
//        let device = Device(bridgeInfo: .init(name: "Test", serialNumber: "00066B"), setupCode: "123-44-321", storage: MemoryStorage(), accessories: [thermostat, lamp])
//        let application = characteristics(device: device)
//
//        let connection = MockContext()
//        withExtendedLifetime(connection) {
//
//            // subscribe to lamp events
//            do {
//                let body = try! JSONSerialization.data(withJSONObject: [
//                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "ev": true]]
//                ], options: [])
//                let response = application(connection, HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                XCTAssertEqual(response.status, .noContent)
//            }
//
//            // setup our expectations
//            let receiveEvent = expectation(description: "should not receive an event")
//            connection.sideChannelCallback = { _ in receiveEvent.fulfill() }
//            receiveEvent.isInverted = true
//
//            // turn lamp on
//            do {
//                let body = try! JSONSerialization.data(withJSONObject: [
//                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "value": 1]]
//                ], options: [])
//                let response = application(connection, HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                XCTAssertEqual(response.status, .noContent)
//            }
//
//            // if no event within 10ms, the test succeeds
//            wait(for: [receiveEvent], timeout: 0.01)
//        }
    }

    func testSingleEventPerUpdate() {
//        let thermostat = Accessory.Thermostat(info: .init(name: "Thermostat", serialNumber: "00067"))
//        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00068"))
//        let device = Device(bridgeInfo: .init(name: "Test", serialNumber: "00069"), setupCode: "123-44-321", storage: MemoryStorage(), accessories: [thermostat, lamp])
//        let application = characteristics(device: device)
//
//        let connection = MockContext()
//        withExtendedLifetime(connection) {
//
//            // subscribe to lamp events
//            do {
//                let body = try! JSONSerialization.data(withJSONObject: [
//                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "ev": true]]
//                ], options: [])
//                let response = application(connection, HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                XCTAssertEqual(response.status, .noContent)
//            }
//
//            // turn lamp on
//            do {
//                let body = try! JSONSerialization.data(withJSONObject: [
//                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "value": 1]]
//                ], options: [])
//                let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                XCTAssertEqual(response.status, .noContent)
//            }
//
//            // if no multiple events within 10ms, the test succeeds
//            wait(for: [receiveEvent], timeout: 0.01)
//        }
    }

    func testDelayMultipleEvents() {
//        let lamp = Accessory.Lightbulb(info: .init(name: "Diner table", serialNumber: "00070"))
//        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
//        let application = characteristics(device: device)
//
//        let connection = MockContext()
//        withExtendedLifetime(connection) {
//
//            // subscribe to lamp events
//            do {
//                let body = try! JSONSerialization.data(withJSONObject: [
//                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "ev": true]]
//                ], options: [])
//                let response = application(connection, HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                XCTAssertEqual(response.status, .noContent)
//            }
//
//            // turn lamp on from different connection
//            var firstEventTimestamp: Date?
//            do {
//                let expectation = XCTestExpectation(description: "should receive an event")
//                connection.sideChannelCallback = { _ in
//                    firstEventTimestamp = Date()
//                    expectation.fulfill()
//                }
//
//                let body = try! JSONSerialization.data(withJSONObject: [
//                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "value": 1]]
//                ], options: [])
//                let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                XCTAssertEqual(response.status, .noContent)
//
//                wait(for: [expectation], timeout: 0.01)
//            }
//
//            // turn lamp off from different connection
//            var secondEventTimestamp: Date?
//            do {
//                let expectation = XCTestExpectation(description: "should receive an event")
//                connection.sideChannelCallback = { _ in
//                    secondEventTimestamp = Date()
//                    expectation.fulfill()
//                }
//                let body = try! JSONSerialization.data(withJSONObject: [
//                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "value": 0]]
//                ], options: [])
//                let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                XCTAssertEqual(response.status, .noContent)
//
//                wait(for: [expectation], timeout: 1.01)
//            }
//
//            if let firstEventTimestamp = firstEventTimestamp, let secondEventTimestamp = secondEventTimestamp {
//                let delay = secondEventTimestamp.timeIntervalSince(firstEventTimestamp)
//                XCTAssert(delay >= 0.99, "received event in \(delay) seconds of previous event, events should be sent at a interval of 1 seconds or more")
//            }
//        }
    }

    func testDelayMultipleEventsCoalescence() {
//        let thermostat = Accessory.Thermostat(info: .init(name: "Thermostat", serialNumber: "00071"))
//        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", serialNumber: "00072"))
//        let device = Device(bridgeInfo: .init(name: "Test", serialNumber: "00072B"), setupCode: "123-44-321", storage: MemoryStorage(), accessories: [thermostat, lamp])
//        let application = characteristics(device: device)
//
//        let connection = MockContext()
//        withExtendedLifetime(connection) {
//
//            // subscribe to lamp events
//            do {
//                let body = try! JSONSerialization.data(withJSONObject: [
//                    "characteristics": [
//                        ["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "ev": true],
//                        ["aid": thermostat.aid, "iid": thermostat.thermostat.targetTemperature.iid, "ev": true]
//                    ]
//                ], options: [])
//                let response = application(connection, HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                XCTAssertEqual(response.status, .noContent)
//            }
//
//            // first event: turn lamp on from different connection
//            var firstEventTimestamp: Date?
//            do {
//                let expectation = XCTestExpectation(description: "should receive an event")
//                connection.sideChannelCallback = { _ in
//                    firstEventTimestamp = Date()
//                    expectation.fulfill()
//                }
//
//                let body = try! JSONSerialization.data(withJSONObject: [
//                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "value": 1]]
//                ], options: [])
//                let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                XCTAssertEqual(response.status, .noContent)
//
//                wait(for: [expectation], timeout: 0.01)
//            }
//
//            var secondEventTimestamp: Date?
//            var secondEventData: Data?
//            do {
//                let expectation = XCTestExpectation(description: "should receive an single event")
//                expectation.assertForOverFulfill = true
//                connection.sideChannelCallback = { data in
//                    secondEventTimestamp = Date()
//                    secondEventData = data
//                    expectation.fulfill()
//                }
//                // second update: turn lamp off
//                do {
//                    let body = try! JSONSerialization.data(withJSONObject: [
//                        "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "value": 0]]
//                    ], options: [])
//                    let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                    XCTAssertEqual(response.status, .noContent)
//                }
//                // third update: change target temperature
//                do {
//                    let body = try! JSONSerialization.data(withJSONObject: [
//                        "characteristics": [["aid": thermostat.aid, "iid": thermostat.thermostat.targetTemperature.iid, "value": 17.5]]
//                    ], options: [])
//                    let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                    XCTAssertEqual(response.status, .noContent)
//                }
//
//                wait(for: [expectation], timeout: 1.01)
//            }
//
//            guard
//                secondEventData != nil,
//                let event = Event(deserialize: secondEventData!),
//                let eventJson = try? JSONSerialization.jsonObject(with: event.body, options: []),
//                let eventCharacteristics = (eventJson as? [String: Any])?["characteristics"] as? [[String: Any]]
//                else {
//                    XCTFail("Could not decode event")
//                    return
//            }
//            XCTAssert(eventCharacteristics.count == 2, "consecutive updates within the 2-second interval should have coalesced")
//
//            if let firstEventTimestamp = firstEventTimestamp, let secondEventTimestamp = secondEventTimestamp {
//                let delay = secondEventTimestamp.timeIntervalSince(firstEventTimestamp)
//                XCTAssert(delay >= 1, "received event in \(delay) seconds of previous event, events should be sent at a interval of 1 seconds or more")
//            }
//        }
    }

    func testDelayMultipleEventsCoalescenceFiltering() {
//        // Either we keep track of the state of a characteristic on individual
//        // and only notify the actual changes. Or we only send the last relevant
//        // state of a characteristic. This test assumes the latter, so if we
//        // change to the other, this test needs to check for absence of updates
//        // instead.
//
//        let lamp = Accessory.Lightbulb(info: .init(name: "Kitchen table", serialNumber: "00074"))
//        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
//        let application = characteristics(device: device)
//
//        let connection = MockContext()
//        withExtendedLifetime(connection) {
//
//            // subscribe to lamp events
//            do {
//                let body = try! JSONSerialization.data(withJSONObject: [
//                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "ev": true]]
//                ], options: [])
//                let response = application(connection, HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                XCTAssertEqual(response.status, .noContent)
//            }
//
//            // first event: turn lamp on from different connection
//            var firstEventTimestamp: Date?
//            do {
//                let expectation = XCTestExpectation(description: "should receive an event")
//                connection.sideChannelCallback = { _ in
//                    firstEventTimestamp = Date()
//                    expectation.fulfill()
//                }
//
//                let body = try! JSONSerialization.data(withJSONObject: [
//                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "value": 1]]
//                ], options: [])
//                let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                XCTAssertEqual(response.status, .noContent)
//
//                wait(for: [expectation], timeout: 0.01)
//            }
//
//            var secondEventTimestamp: Date?
//            var secondEventData: Data?
//            do {
//                let expectation = XCTestExpectation(description: "should receive an single event")
//                expectation.assertForOverFulfill = true
//                connection.sideChannelCallback = { data in
//                    secondEventTimestamp = Date()
//                    secondEventData = data
//                    expectation.fulfill()
//                }
//                // second update: turn lamp off
//                do {
//                    let body = try! JSONSerialization.data(withJSONObject: [
//                        "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "value": 0]]
//                    ], options: [])
//                    let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                    XCTAssertEqual(response.status, .noContent)
//                }
//                // second update: turn lamp on again
//                do {
//                    let body = try! JSONSerialization.data(withJSONObject: [
//                        "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.powerState.iid, "value": 1]]
//                    ], options: [])
//                    let response = application(MockContext(), HTTPRequest(method: .PUT, uri: "/characteristics", body: body))
//                    XCTAssertEqual(response.status, .noContent)
//                }
//
//                wait(for: [expectation], timeout: 1.01)
//            }
//
//            if let firstEventTimestamp = firstEventTimestamp, let secondEventTimestamp = secondEventTimestamp {
//                let delay = secondEventTimestamp.timeIntervalSince(firstEventTimestamp)
//                XCTAssert(delay >= 1, "received event in \(delay) seconds of previous event, events should be sent at a interval of 1 seconds or more")
//            }
//
//            guard
//                secondEventData != nil,
//                let event = Event(deserialize: secondEventData!),
//                let eventJson = try? JSONSerialization.jsonObject(with: event.body, options: []),
//                let eventCharacteristics = (eventJson as? [String: Any])?["characteristics"] as? [[String: Any]]
//                else {
//                    XCTFail("Could not decode event")
//                    return
//            }
//            XCTAssertEqual(eventCharacteristics.count, 1, "when a characteristic receives multiple updates within the coalescing window, we should only send the last relevant update, not all intermediate updates")
//            XCTAssertEqual(eventCharacteristics[0]["value"] as? On, true, "the lamp should be on")
//        }
    }
    #endif

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
