// swiftlint:disable force_try line_length
import Foundation
@testable import HAP
import VaporHTTP
import XCTest

class PairingsEndpointTests: XCTestCase {
    var device: Device!
    var context: MockContext!
    var pairing: Pairing!
    var application: Responder!

    override func setUp() {
        device = Device(bridgeInfo: .init(name: "Test", serialNumber: "00072B"), setupCode: "123-44-321", storage: MemoryStorage(), accessories: [])
        device.controllerHandler = ControllerHandler()
        context = MockContext()
        application = pairings(device: device)
    }

    func testListPairingsNonAdmin() {
        setupPairingWithRole(.regularUser)
        let request = [
            (PairTag.state, Data([PairStep.request.rawValue])),
            (PairTag.pairingMethod, Data([PairingMethod.listPairings.rawValue]))
        ]
        let (_, responseBody) = call(request)
        XCTAssertEqual(responseBody?.error, PairError.authenticationFailed)
    }

    func testListPairingsAdmin() {
        setupPairingWithRole(.admin)
        let request = [
            (PairTag.state, Data([PairStep.request.rawValue])),
            (PairTag.pairingMethod, Data([PairingMethod.listPairings.rawValue]))
        ]
        let (_, responseBody) = call(request)
        XCTAssertEqual(responseBody?.pairStep, PairStep.response)
        XCTAssertEqual(responseBody?.error, nil)
        XCTAssertEqual(responseBody?.count, 4) // state, identifier, publicKey, permissions
    }

    func setupPairingWithRole(_ role: Pairing.Role) {
        pairing = Pairing(identifier: Data(), publicKey: Data(), role: role)
        device.controllerHandler!.registerPairing(pairing, forChannel: context.channel)
        device.add(pairing: pairing)
    }

    func call(_ data: PairTagTLV8) -> (HTTPResponse, PairTagTLV8?) {
        let response = context.call(application, HTTPRequest(method: .POST, uri: "/pairings", body: encode(data)))
        return (response, try! decode(response.body.data!))
    }
}
