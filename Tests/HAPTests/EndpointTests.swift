import Foundation
@testable import HAP
@testable import KituraNet
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
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left"))
        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
        let application = accessories(device: device)
        let response = application(MockConnection(), MockRequest.get(path: "/accessories"))
        let jsonObject = try! JSONSerialization.jsonObject(with: response.body!, options: []) as! [String: [[String: Any]]]
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

    func testGetCharacteristics() {
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", manufacturer: "Bouke"))
        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
        let application = characteristics(device: device)
        let response = application(MockConnection(), MockRequest.get(path: "/characteristics?id=\(lamp.aid).\(lamp.info.manufacturer.iid),\(lamp.aid).\(lamp.info.name.iid)"))
        guard let jsonObject = (try? JSONSerialization.jsonObject(with: response.body!, options: [])) as? [String: [[String: Any]]] else {
            return XCTFail("Could not decode")
        }
        guard let characteristics = jsonObject["characteristics"] else {
            return XCTFail("No characteristics")
        }

        guard let manufacturerCharacteristic = characteristics.first(where: { $0["iid"] as? Int == lamp.info.manufacturer.iid }) else {
            return XCTFail("No manufacturer")
        }
        XCTAssertEqual(manufacturerCharacteristic["value"] as? String, "Bouke")

        guard let nameCharacteristic = characteristics.first(where: { $0["iid"] as? Int == lamp.info.name.iid }) else {
            return XCTFail("No name")
        }
        XCTAssertEqual(nameCharacteristic["value"] as? String, "Night stand left")
    }

    func testPutBoolAndIntCharacteristics() {
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", manufacturer: "Bouke"))
        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
        let application = characteristics(device: device)

        lamp.lightbulb.on.value = false
        lamp.lightbulb.brightness.value = 0

        // turn lamp on
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "iid": lamp.lightbulb.on.iid,
                        "value": 1
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(lamp.lightbulb.on.value, true)
        }

        // 50% brightness
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "iid": lamp.lightbulb.brightness.iid,
                        "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(lamp.lightbulb.brightness.value, 50)
        }

        // 100% brightness
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "iid": lamp.lightbulb.brightness.iid,
                        "value": Double(100)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(lamp.lightbulb.brightness.value, 100)
        }
    }

    func testPutDoubleAndEnumCharacteristics() {
        let thermostat = Accessory.Thermostat(info: .init(name: "Thermostat", manufacturer: "Bouke"))
        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: thermostat)
        let application = characteristics(device: device)

        thermostat.thermostat.currentHeatingCoolingState.value = .off
        thermostat.thermostat.currentTemperature.value = 18

        thermostat.thermostat.targetHeatingCoolingState.value = .off
        thermostat.thermostat.targetTemperature.value = 15

        // turn up the heat
        do {
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
                        "value": TargetHeatingCoolingState.auto.rawValue
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(thermostat.thermostat.targetTemperature.value, 19.5)
            XCTAssertEqual(thermostat.thermostat.targetHeatingCoolingState.value, .auto)
        }

        // turn up the heat some more (value is an Int on Linux, needs to be cast to Double)
        do {
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
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(thermostat.thermostat.targetTemperature.value, 20)
        }

        // turn off
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.thermostat.targetHeatingCoolingState.iid,
                        "value": TargetHeatingCoolingState.off.rawValue
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(thermostat.thermostat.targetHeatingCoolingState.value, .off)
        }

        // wirting all Apple defined properties
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.thermostat.targetHeatingCoolingState.iid,
                        "value": TargetHeatingCoolingState.off.rawValue,
                        "ev": true,
                        "authData": "string",
                        "remote": true
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .noContent)
            XCTAssertEqual(thermostat.thermostat.targetHeatingCoolingState.value, .off)
        }
    }

    func testPutBadCharacteristics() {
        let thermostat = Accessory.Thermostat(info: .init(name: "Thermostat"))
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left"))
        let device = Device(bridgeInfo: .init(name: "Test"), setupCode: "123-44-321", storage: MemoryStorage(), accessories: [thermostat, lamp])
        let application = characteristics(device: device)

        // Writing to read only value should not succeed.
        do {
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
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
        }

        // Writing incorrect value should not succeed.
        do {
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
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
            let json = try! JSONSerialization.jsonObject(with: response.body!)  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int, HAPStatusCodes.invalidValue.rawValue)
        }

        // Writing two values, one should fail as it is read only, the other
        // should succeed.
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.info.manufacturer.iid,
                        "value": "value"
                    ],
                    [
                        "aid": lamp.aid,
                        "iid": lamp.lightbulb.brightness.iid,
                        "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .multiStatus)
            XCTAssertEqual(lamp.lightbulb.brightness.value, 50)

            let json = try! JSONSerialization.jsonObject(with: response.body!)  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int, HAPStatusCodes.readOnly.rawValue)
            XCTAssertEqual(json["characteristics"]![1]["status"]! as! Int, HAPStatusCodes.success.rawValue)

        }

        // Writing two values, both should fail as the first one is read only
        // and the second receives an invalid value.
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.info.manufacturer.iid,
                        "value": "value"
                    ],
                    [
                        "aid": lamp.aid,
                        "iid": lamp.lightbulb.on.iid,
                        "value": "value"
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .multiStatus)

            let json = try! JSONSerialization.jsonObject(with: response.body!)  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int, HAPStatusCodes.readOnly.rawValue)
            XCTAssertEqual(json["characteristics"]![1]["status"]! as! Int, HAPStatusCodes.invalidValue.rawValue)

        }

        // Writing two values, one should succeed and the other should fail as it is read only.
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "iid": lamp.lightbulb.brightness.iid,
                        "value": Double(50)
                    ],
                    [
                        "aid": thermostat.aid,
                        "iid": thermostat.info.firmwareRevision.iid,
                        "value": "value"
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .multiStatus)
            XCTAssertEqual(lamp.lightbulb.brightness.value, 50)

            let json = try! JSONSerialization.jsonObject(with: response.body!)  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int, HAPStatusCodes.success.rawValue)
            XCTAssertEqual(json["characteristics"]![1]["status"]! as! Int, HAPStatusCodes.readOnly.rawValue)
        }

        // Writing two values, both should fail as they are read only.
        do {
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
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .multiStatus)
            XCTAssertEqual(lamp.lightbulb.brightness.value, 50)

            let json = try! JSONSerialization.jsonObject(with: response.body!)  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int, HAPStatusCodes.readOnly.rawValue)
            XCTAssertEqual(json["characteristics"]![1]["status"]! as! Int, HAPStatusCodes.readOnly.rawValue)

        }

        // "400 Bad Request" on HAP client error, e.g. a malformed request
        // at least one of `value` or `ev` should be present.
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "iid": lamp.info.serialNumber.iid
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
        }

        // Leaving out the `iid` field should not succeed.
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": lamp.aid,
                        "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
        }

        // Leaving out the `aid` field should not succeed.
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "iid": lamp.info.serialNumber.iid,
                        "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
        }

        // "422 Unprocessable Entity" for a well-formed request that contains
        // invalid parameters.
        do {
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
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .unprocessableEntity)
        }

        // "422 Unprocessable Entity" for a well-formed request that contains
        // invalid parameters.
        do {
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
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .unprocessableEntity)
        }
    }

    func testGetBadCharacteristics() {
        let lightsensor = Accessory.LightSensor(info: .init(name: "LightSensor"))
        let thermostat = Accessory.Thermostat(info: .init(name: "Thermostat"))
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left"))

        lightsensor.lightSensor.currentLight.value = 234
        thermostat.thermostat.currentTemperature.value = 123
        lamp.lightbulb.brightness.value = 53
        let device = Device(bridgeInfo: .init(name: "Test"), setupCode: "123-44-321", storage: MemoryStorage(), accessories: [lightsensor, thermostat, lamp])
        let application = characteristics(device: device)

        // First a good one
        do {
            let req = "\(lamp.aid).\(lamp.lightbulb.brightness.iid),\(lightsensor.aid).\(lightsensor.lightSensor.currentLight.iid),\(thermostat.aid).\(thermostat.thermostat.currentTemperature.iid)"
            let response = application(MockConnection(), MockRequest.get(path: "/characteristics?id=\(req)"))

            XCTAssertEqual(response.status, .ok)

            guard let jsonObject = (try? JSONSerialization.jsonObject(with: response.body!, options: [])) as? [String: [[String: Any]]] else {
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

            guard let lightVal = Double(value: light["value"] as Any) else {
                return XCTFail("light is not Double")
            }

            guard let thermVal = Double(value: therm["value"] as Any) else {
                return XCTFail("therm is not Double")
            }

            guard let lampaVal = Int(value: lampa["value"] as Any) else {
                return XCTFail("therm is not Int")
            }

            XCTAssertEqual(lightVal, lightsensor.lightSensor.currentLight.value)
            XCTAssertEqual(thermVal, thermostat.thermostat.currentTemperature.value)
            XCTAssertEqual(lampaVal, lamp.lightbulb.brightness.value)
        }

        // trying to read write only access
        do {
            let iid = lightsensor.info.identify.iid
            let aid = lightsensor.aid
            let response = application(MockConnection(), MockRequest.get(path: "/characteristics?id=\(aid).\(iid)"))
            XCTAssertEqual(response.status, .multiStatus)
            let json = try! JSONSerialization.jsonObject(with: response.body!)  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int, HAPStatusCodes.writeOnly.rawValue)
            XCTAssertEqual(json["characteristics"]![0]["aid"]! as! Int, aid)
            XCTAssertEqual(json["characteristics"]![0]["iid"]! as! Int, iid)
        }

        // trying to read write only access and one with read access
        do {
            let iid = lightsensor.info.identify.iid
            let aid = lightsensor.aid
            let iid2 = thermostat.thermostat.currentTemperature.iid
            let aid2 = thermostat.aid
            let response = application(MockConnection(), MockRequest.get(path: "/characteristics?id=\(aid2).\(iid2),\(aid).\(iid)"))
            XCTAssertEqual(response.status, .multiStatus)
            guard let jsonObject = (try? JSONSerialization.jsonObject(with: response.body!, options: [])) as? [String: [[String: Any]]] else {
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
            XCTAssertEqual(Double(value: therm["value"] as Any), thermostat.thermostat.currentTemperature.value)
        }

        // trying to read write only access and one with read access, reverse order
        do {
            let iid = lightsensor.info.identify.iid
            let aid = lightsensor.aid
            let iid2 = thermostat.thermostat.currentTemperature.iid
            let aid2 = thermostat.aid
            let response = application(MockConnection(), MockRequest.get(path: "/characteristics?id=\(aid).\(iid),\(aid2).\(iid2)"))
            XCTAssertEqual(response.status, .multiStatus)
            guard let jsonObject = (try? JSONSerialization.jsonObject(with: response.body!, options: [])) as? [String: [[String: Any]]] else {
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
            XCTAssertEqual(Double(value: therm["value"] as Any), thermostat.thermostat.currentTemperature.value)
        }
    }

    func testAuthentication() {
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left"))
        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
        let application = root(device: device)
        do {
            let response = application(MockConnection(), MockRequest.get(path: "/identify"))
            XCTAssertEqual(response.status, .forbidden)
        }
        do {
            let response = application(MockConnection(), MockRequest.get(path: "/accessories"))
            XCTAssertEqual(response.status, .forbidden)
        }
        do {
            let response = application(MockConnection(), MockRequest.get(path: "/characteristics"))
            XCTAssertEqual(response.status, .forbidden)
        }
        do {
            let response = application(MockConnection(), MockRequest.get(path: "/pairings"))
            XCTAssertEqual(response.status, .forbidden)
        }
    }

  #if os(macOS)
    func testNoEventsToSelf() {
        let thermostat = Accessory.Thermostat(info: .init(name: "Thermostat"))
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left"))
        let device = Device(bridgeInfo: .init(name: "Test"), setupCode: "123-44-321", storage: MemoryStorage(), accessories: [thermostat, lamp])
        let application = characteristics(device: device)

        let connection = MockConnection()
        withExtendedLifetime(connection) {

            // subscribe to lamp events
            do {
                let body = try! JSONSerialization.data(withJSONObject: [
                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "ev": true]]
                    ], options: [])
                let response = application(connection, MockRequest(method: "PUT", path: "/characteristics", body: body))
                XCTAssertEqual(response.status, .noContent)
            }

            // setup our expectations
            let receiveEvent = expectation(description: "should not receive an event")
            connection.sideChannelCallback = { _ in receiveEvent.fulfill() }
            receiveEvent.isInverted = true

            // turn lamp on
            do {
                let body = try! JSONSerialization.data(withJSONObject: [
                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "value": 1]]
                    ], options: [])
                let response = application(connection, MockRequest(method: "PUT", path: "/characteristics", body: body))
                XCTAssertEqual(response.status, .noContent)
            }

            // if no event within 10ms, the test succeeds
            wait(for: [receiveEvent], timeout: 0.01)
        }
    }

    func testSingleEventPerUpdate() {
        let thermostat = Accessory.Thermostat(info: .init(name: "Thermostat"))
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left"))
        let device = Device(bridgeInfo: .init(name: "Test"), setupCode: "123-44-321", storage: MemoryStorage(), accessories: [thermostat, lamp])
        let application = characteristics(device: device)

        let connection = MockConnection()
        withExtendedLifetime(connection) {

            // subscribe to lamp events
            do {
                let body = try! JSONSerialization.data(withJSONObject: [
                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "ev": true]]
                    ], options: [])
                let response = application(connection, MockRequest(method: "PUT", path: "/characteristics", body: body))
                XCTAssertEqual(response.status, .noContent)
            }

            // setup our expectations
            let receiveEvent = expectation(description: "should not receive an event")
            receiveEvent.assertForOverFulfill = true
            connection.sideChannelCallback = { _ in receiveEvent.fulfill() }

            // turn lamp on
            do {
                let body = try! JSONSerialization.data(withJSONObject: [
                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "value": 1]]
                    ], options: [])
                let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
                XCTAssertEqual(response.status, .noContent)
            }

            // if no multiple events within 10ms, the test succeeds
            wait(for: [receiveEvent], timeout: 0.01)
        }
    }

    func testDelayMultipleEvents() {
        let lamp = Accessory.Lightbulb(info: .init(name: "Diner table"))
        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
        let application = characteristics(device: device)

        let connection = MockConnection()
        withExtendedLifetime(connection) {

            // subscribe to lamp events
            do {
                let body = try! JSONSerialization.data(withJSONObject: [
                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "ev": true]]
                ], options: [])
                let response = application(connection, MockRequest(method: "PUT", path: "/characteristics", body: body))
                XCTAssertEqual(response.status, .noContent)
            }

            // turn lamp on from different connection
            var firstEventTimestamp: Date?
            do {
                let expectation = XCTestExpectation(description: "should receive an event")
                connection.sideChannelCallback = { _ in
                    firstEventTimestamp = Date()
                    expectation.fulfill()
                }

                let body = try! JSONSerialization.data(withJSONObject: [
                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "value": 1]]
                    ], options: [])
                let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
                XCTAssertEqual(response.status, .noContent)

                wait(for: [expectation], timeout: 0.01)
            }

            // turn lamp off from different connection
            var secondEventTimestamp: Date?
            do {
                let expectation = XCTestExpectation(description: "should receive an event")
                connection.sideChannelCallback = { _ in
                    secondEventTimestamp = Date()
                    expectation.fulfill()
                }
                let body = try! JSONSerialization.data(withJSONObject: [
                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "value": 0]]
                    ], options: [])
                let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
                XCTAssertEqual(response.status, .noContent)

                wait(for: [expectation], timeout: 1.01)
            }

            if let firstEventTimestamp = firstEventTimestamp, let secondEventTimestamp = secondEventTimestamp {
                let delay = secondEventTimestamp.timeIntervalSince(firstEventTimestamp)
                XCTAssert(delay >= 1, "received event in \(delay) seconds of previous event, events should be sent at a interval of 1 seconds or more")
            }
        }
    }

    func testDelayMultipleEventsCoalescence() {
        let thermostat = Accessory.Thermostat(info: .init(name: "Thermostat"))
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left"))
        let device = Device(bridgeInfo: .init(name: "Test"), setupCode: "123-44-321", storage: MemoryStorage(), accessories: [thermostat, lamp])
        let application = characteristics(device: device)

        let connection = MockConnection()
        withExtendedLifetime(connection) {

            // subscribe to lamp events
            do {
                let body = try! JSONSerialization.data(withJSONObject: [
                    "characteristics": [
                        ["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "ev": true],
                        ["aid": thermostat.aid, "iid": thermostat.thermostat.targetTemperature.iid, "ev": true]
                    ]], options: [])
                let response = application(connection, MockRequest(method: "PUT", path: "/characteristics", body: body))
                XCTAssertEqual(response.status, .noContent)
            }

            // first event: turn lamp on from different connection
            var firstEventTimestamp: Date?
            do {
                let expectation = XCTestExpectation(description: "should receive an event")
                connection.sideChannelCallback = { _ in
                    firstEventTimestamp = Date()
                    expectation.fulfill()
                }

                let body = try! JSONSerialization.data(withJSONObject: [
                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "value": 1]]
                    ], options: [])
                let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
                XCTAssertEqual(response.status, .noContent)

                wait(for: [expectation], timeout: 0.01)
            }

            var secondEventTimestamp: Date?
            var secondEventData: Data?
            do {
                let expectation = XCTestExpectation(description: "should receive an single event")
                expectation.assertForOverFulfill = true
                connection.sideChannelCallback = { (data) in
                    secondEventTimestamp = Date()
                    secondEventData = data
                    expectation.fulfill()
                }
                // second update: turn lamp off
                do {
                    let body = try! JSONSerialization.data(withJSONObject: [
                        "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "value": 0]]
                        ], options: [])
                    let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
                    XCTAssertEqual(response.status, .noContent)
                }
                // third update: change target temperature
                do {
                    let body = try! JSONSerialization.data(withJSONObject: [
                        "characteristics": [["aid": thermostat.aid, "iid": thermostat.thermostat.targetTemperature.iid, "value": 17.5]]
                        ], options: [])
                    let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
                    XCTAssertEqual(response.status, .noContent)
                }

                wait(for: [expectation], timeout: 1.01)
            }

            guard
                secondEventData != nil,
                let event = Event(deserialize: secondEventData!),
                let eventJson = try? JSONSerialization.jsonObject(with: event.body, options: []),
                let eventCharacteristics = (eventJson as? [String: Any])?["characteristics"] as? [[String: Any]]
                else {
                    XCTFail("Could not decode event")
                    return
            }
            XCTAssert(eventCharacteristics.count == 2, "consecutive updates within the 2-second interval should have coalesced")

            if let firstEventTimestamp = firstEventTimestamp, let secondEventTimestamp = secondEventTimestamp {
                let delay = secondEventTimestamp.timeIntervalSince(firstEventTimestamp)
                XCTAssert(delay >= 1, "received event in \(delay) seconds of previous event, events should be sent at a interval of 1 seconds or more")
            }
        }
    }

    func testDelayMultipleEventsCoalescenceFiltering() {
        // Either we keep track of the state of a characteristic on individual
        // and only notify the actual changes. Or we only send the last relevant
        // state of a characteristic. This test assumes the latter, so if we
        // change to the other, this test needs to check for absence of updates
        // instead.

        let lamp = Accessory.Lightbulb(info: .init(name: "Kitchen table"))
        let device = Device(setupCode: "123-44-321", storage: MemoryStorage(), accessory: lamp)
        let application = characteristics(device: device)

        let connection = MockConnection()
        withExtendedLifetime(connection) {

            // subscribe to lamp events
            do {
                let body = try! JSONSerialization.data(withJSONObject: [
                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "ev": true]]
                    ], options: [])
                let response = application(connection, MockRequest(method: "PUT", path: "/characteristics", body: body))
                XCTAssertEqual(response.status, .noContent)
            }

            // first event: turn lamp on from different connection
            var firstEventTimestamp: Date?
            do {
                let expectation = XCTestExpectation(description: "should receive an event")
                connection.sideChannelCallback = { _ in
                    firstEventTimestamp = Date()
                    expectation.fulfill()
                }

                let body = try! JSONSerialization.data(withJSONObject: [
                    "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "value": 1]]
                    ], options: [])
                let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
                XCTAssertEqual(response.status, .noContent)

                wait(for: [expectation], timeout: 0.01)
            }

            var secondEventTimestamp: Date?
            var secondEventData: Data?
            do {
                let expectation = XCTestExpectation(description: "should receive an single event")
                expectation.assertForOverFulfill = true
                connection.sideChannelCallback = { (data) in
                    secondEventTimestamp = Date()
                    secondEventData = data
                    expectation.fulfill()
                }
                // second update: turn lamp off
                do {
                    let body = try! JSONSerialization.data(withJSONObject: [
                        "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "value": 0]]
                        ], options: [])
                    let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
                    XCTAssertEqual(response.status, .noContent)
                }
                // second update: turn lamp on again
                do {
                    let body = try! JSONSerialization.data(withJSONObject: [
                        "characteristics": [["aid": lamp.aid, "iid": lamp.lightbulb.on.iid, "value": 1]]
                        ], options: [])
                    let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
                    XCTAssertEqual(response.status, .noContent)
                }

                wait(for: [expectation], timeout: 1.01)
            }

            if let firstEventTimestamp = firstEventTimestamp, let secondEventTimestamp = secondEventTimestamp {
                let delay = secondEventTimestamp.timeIntervalSince(firstEventTimestamp)
                XCTAssert(delay >= 1, "received event in \(delay) seconds of previous event, events should be sent at a interval of 1 seconds or more")
            }

            guard
                secondEventData != nil,
                let event = Event(deserialize: secondEventData!),
                let eventJson = try? JSONSerialization.jsonObject(with: event.body, options: []),
                let eventCharacteristics = (eventJson as? [String: Any])?["characteristics"] as? [[String: Any]]
                else {
                    XCTFail("Could not decode event")
                    return
            }
            XCTAssertEqual(eventCharacteristics.count, 1, "when a characteristic receives multiple updates within the coalescing window, we should only send the last relevant update, not all intermediate updates")
            XCTAssertEqual(eventCharacteristics[0]["value"] as? On, true, "the lamp should be on")
        }
    }
  #endif

    // from: https://oleb.net/blog/2017/03/keeping-xctest-in-sync/#appendix-code-generation-with-sourcery
    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let thisClass = type(of: self)
            let linuxCount = thisClass.allTests.count
            let darwinCount = Int(thisClass
                .defaultTestSuite.testCaseCount)
            XCTAssertEqual(linuxCount, darwinCount,
                           "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
