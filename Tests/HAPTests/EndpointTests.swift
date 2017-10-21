import Foundation
@testable import HAP
@testable import KituraNet
import XCTest

class EndpointTests: XCTestCase {
    static var allTests : [(String, (EndpointTests) -> () throws -> Void)] {
        return [
            ("testAccessories", testAccessories),
            ("testGetCharacteristics", testGetCharacteristics),
            ("testPutBoolAndIntCharacteristics", testPutBoolAndIntCharacteristics),
            ("testPutDoubleAndEnumCharacteristics", testPutDoubleAndEnumCharacteristics),
            ("testPutBadCharacteristics", testPutBadCharacteristics),
            ("testGetBadCharacteristics", testGetBadCharacteristics),
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
        
        guard let lampCharacteristics = lampService["characteristics"] as? [[String: Any]] else {
            return XCTFail("No lamp characteristics")
        }
        XCTAssertEqual(lampCharacteristics.count, 4)
    }

    
    /// This test assumes that 1.3 and 1.5 are respectively `manufacturer` and
    /// `name`. This does not need to be the case.
    func testGetCharacteristics() {
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
    
    /// This test assumes that 1.3 and 1.5 are respectively `manufacturer` and
    /// `name`. This does not need to be the case.
    func testPutBoolAndIntCharacteristics() {
        let lamp = Accessory.Lightbulb(info: .init(name: "Night stand left", manufacturer: "Bouke"))
        let device = Device(name: "Test", pin: "123-44-321", storage: MemoryStorage(), accessories: [lamp])
        let application = characteristics(device: device)
        
        lamp.lightbulb.on.value = false
        lamp.lightbulb.brightness.value = 0

        // turn lamp on
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": 1,
                        "iid": 8,
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
                        "aid": 1,
                        "iid": 9,
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
                        "aid": 1,
                        "iid": 9,
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

    /// This test assumes that 1.3 and 1.5 are respectively `manufacturer` and
    /// `name`. This does not need to be the case.
    func testPutDoubleAndEnumCharacteristics() {
        let thermostat = Accessory.Thermostat(info: .init(name: "Thermostat", manufacturer: "Bouke"))
        let device = Device(name: "Test", pin: "123-44-321", storage: MemoryStorage(), accessories: [thermostat])
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
                        "aid": 1,
                        "iid": 11,
                        "value": 19.5
                    ],
                    [
                        "aid": 1,
                        "iid": 9,
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
                        "aid": 1,
                        "iid": 11,
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
                        "aid": 1,
                        "iid": 9,
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
                        "aid": 1,
                        "iid": 9,
                        "value": TargetHeatingCoolingState.off.rawValue,
                        "ev" : true,
                        "authData" : "string",
                        "remote" : true
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
        let device = Device(name: "Test", pin: "123-44-321", storage: MemoryStorage(), accessories: [thermostat,lamp])
        let application = characteristics(device: device)

        // writing to read only
        
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": 1,
                        "iid": 3,
                        "value": "value"
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
        }
        
        // invalid value in a write request
        
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": 1,
                        "iid": 9,
                        "value": "value"
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
            let json = try! JSONSerialization.jsonObject(with: response.body!)  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int,HAPStatusCodes.invalidValue.rawValue)
        }

        
        // writing two values, first read only
        
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": 1,
                        "iid": 3,
                        "value": "value"
                    ],
                    [
                        "aid": 2,
                        "iid": 9,
                        "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .multiStatus)
            XCTAssertEqual(lamp.lightbulb.brightness.value, 50)
            
            let json = try! JSONSerialization.jsonObject(with: response.body!)  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int,HAPStatusCodes.readOnly.rawValue)
            XCTAssertEqual(json["characteristics"]![1]["status"]! as! Int,HAPStatusCodes.success.rawValue)

        }
        
        // writing two values, first read only, second invalid value
        
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": 1,
                        "iid": 3,
                        "value": "value"
                    ],
                    [
                        "aid": 2,
                        "iid": 9,
                        "value": "value"
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .multiStatus)
            
            let json = try! JSONSerialization.jsonObject(with: response.body!)  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int,HAPStatusCodes.readOnly.rawValue)
            XCTAssertEqual(json["characteristics"]![1]["status"]! as! Int,HAPStatusCodes.invalidValue.rawValue)
            
        }

        
        // writing two values, second read only
        
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": 2,
                        "iid": 9,
                        "value": Double(50)
                    ],
                    [
                        "aid": 1,
                        "iid": 3,
                        "value": "value"
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .multiStatus)
            XCTAssertEqual(lamp.lightbulb.brightness.value, 50)
            
            let json = try! JSONSerialization.jsonObject(with: response.body!)  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![1]["status"]! as! Int,HAPStatusCodes.readOnly.rawValue)
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int,HAPStatusCodes.success.rawValue)
            
        }

        
        // writing two values, both read only

        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": 1,
                        "iid": 3,
                        "value": "value"
                    ],
                    [
                        "aid": 2,
                        "iid": 4,
                        "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .multiStatus)
            XCTAssertEqual(lamp.lightbulb.brightness.value, 50)
            
            let json = try! JSONSerialization.jsonObject(with: response.body!)  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int,HAPStatusCodes.readOnly.rawValue)
            XCTAssertEqual(json["characteristics"]![1]["status"]! as! Int,HAPStatusCodes.readOnly.rawValue)
            
        }
        
        // 400 Bad Request+ on HAP client error, e.g. a malformed request
        // at least one of value or ev should be present
        
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": 2,
                        "iid": 4,
                     //   "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
        }
        
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                        "aid": 2,
                 //       "iid": 4,
                        "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
        }
        do {
            let jsonObject: [String: [[String: Any]]] = [
                "characteristics": [
                    [
                   //     "aid": 2,
                        "iid": 4,
                        "value": Double(50)
                    ]
                ]
            ]
            let body = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
            let response = application(MockConnection(), MockRequest(method: "PUT", path: "/characteristics", body: body))
            XCTAssertEqual(response.status, .badRequest)
        }


        
        // 422 Unprocessable Entity+ for a well-formed request that contains invalid parameters


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
        let device = Device(name: "Test", pin: "123-44-321", storage: MemoryStorage(), accessories: [lightsensor,thermostat,lamp])
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
        
        let light = characteristics.first { $0["aid"] as! Int == lightsensor.aid }!
        let therm = characteristics.first { $0["aid"] as! Int == thermostat.aid }!
        let lampa = characteristics.first { $0["aid"] as! Int == lamp.aid }!

        XCTAssertEqual(light["value"] as? Double, lightsensor.lightSensor.currentLight.value)
        XCTAssertEqual(therm["value"] as? Double, thermostat.thermostat.currentTemperature.value)
        XCTAssertEqual(lampa["value"] as? Int, lamp.lightbulb.brightness.value)

        }
        
        // trying to read write only access
        
        do {
            let iid = lightsensor.info.identify.iid
            let aid = lightsensor.aid
            let response = application(MockConnection(), MockRequest.get(path: "/characteristics?id=\(aid).\(iid)"))
            XCTAssertEqual(response.status, .multiStatus)
            let json = try! JSONSerialization.jsonObject(with: response.body!)  as! [String: [[String: Any]]]
            XCTAssertEqual(json["characteristics"]![0]["status"]! as! Int,HAPStatusCodes.writeOnly.rawValue)
            XCTAssertEqual(json["characteristics"]![0]["aid"]! as! Int,aid)
            XCTAssertEqual(json["characteristics"]![0]["iid"]! as! Int,iid)
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
            XCTAssertEqual(light["status"] as? Int,HAPStatusCodes.writeOnly.rawValue)
            XCTAssertEqual(therm["status"] as? Int,HAPStatusCodes.success.rawValue)
            XCTAssertEqual(therm["value"] as? Double, thermostat.thermostat.currentTemperature.value)
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
            XCTAssertEqual(light["status"] as? Int,HAPStatusCodes.writeOnly.rawValue)
            XCTAssertEqual(therm["status"] as? Int,HAPStatusCodes.success.rawValue)
            XCTAssertEqual(therm["value"] as? Double, thermostat.thermostat.currentTemperature.value)
        }

        
    }




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
