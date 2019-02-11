// swiftlint:disable force_try line_length
import Foundation
@testable import HAP
import HTTP
import XCTest

class PairingsEndpointTests: XCTestCase {
    static var allTests: [(String, (PairingsEndpointTests) -> () throws -> Void)] {
        return [
            ("testListPairingsNonAdmin", testListPairingsNonAdmin),
            ("testListPairingsAdmin", testListPairingsAdmin),
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
        ]
    }

    var device: Device!
    var connection: MockContext!
    var pairing: Pairing!
    var application: Responder!

    override func setUp() {
        device = Device(bridgeInfo: .init(name: "Test", serialNumber: "00072B"), setupCode: "123-44-321", storage: MemoryStorage(), accessories: [])
        device.controllerHandler = ControllerHandler()
        connection = MockContext()
        application = pairings(device: device)
    }

    func testListPairingsNonAdmin() {
        setupPairingWithRole(.regularUser)
        let request = [
            (PairTag.state, Data(bytes: [PairStep.request.rawValue])),
            (PairTag.pairingMethod, Data(bytes: [PairingMethod.listPairings.rawValue]))
        ]
        let (_, responseBody) = call(request)
        XCTAssertEqual(responseBody?.error, PairError.authenticationFailed)
    }

    func testListPairingsAdmin() {
        setupPairingWithRole(.admin)
        let request = [
            (PairTag.state, Data(bytes: [PairStep.request.rawValue])),
            (PairTag.pairingMethod, Data(bytes: [PairingMethod.listPairings.rawValue]))
        ]
        let (_, responseBody) = call(request)
        XCTAssertEqual(responseBody?.pairStep, PairStep.response)
        XCTAssertEqual(responseBody?.error, nil)
        XCTAssertEqual(responseBody?.count, 4) // state, identifier, publicKey, permissions
    }

    func setupPairingWithRole(_ role: Pairing.Role) {
        pairing = Pairing(identifier: Data(), publicKey: Data(), role: role)
        device.controllerHandler!.registerPairing(pairing, forChannel: connection.channel)
        device.add(pairing: pairing)
    }

    func call(_ data: PairTagTLV8) -> (HTTPResponse, PairTagTLV8?) {
        let response = application(connection, HTTPRequest(method: .POST, uri: "/pairings", body: encode(data)))
        return (response, try! decode(response.body.data!))
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
