// swiftlint:disable force_try line_length
import Foundation
@testable import HAP
@testable import KituraNet
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
    var connection: MockConnection!
    var application: Application!
    override func setUp() {
        device = Device(bridgeInfo: .init(name: "Test", serialNumber: "00072B"), setupCode: "123-44-321", storage: MemoryStorage(), accessories: [])
        connection = MockConnection()
        connection.pairing = Pairing(identifier: Data(), publicKey: Data(), role: .regularUser)
        device.add(pairing: connection.pairing!)
        application = pairings(device: device)
    }

    func call(_ data: PairTagTLV8) -> (Response, PairTagTLV8?) {
        let response = application(connection, MockRequest(method: "POST", path: "/pairings", body: encode(data)))
        return (response, try! decode(response.body!))
    }

    func testListPairingsNonAdmin() {
        let request = [
            (PairTag.state, Data(bytes: [PairStep.request.rawValue])),
            (PairTag.pairingMethod, Data(bytes: [PairingMethod.listPairings.rawValue]))
        ]
        let (_, responseBody) = call(request)
        XCTAssertEqual(responseBody?.error, PairError.authenticationFailed)
    }

    func testListPairingsAdmin() {
        connection.pairing?.role = .admin
        let request = [
            (PairTag.state, Data(bytes: [PairStep.request.rawValue])),
            (PairTag.pairingMethod, Data(bytes: [PairingMethod.listPairings.rawValue]))
        ]
        let (_, responseBody) = call(request)
        XCTAssertEqual(responseBody?.pairStep, PairStep.response)
        XCTAssertEqual(responseBody?.count, 4) // state, identifier, publicKey, permissions
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
