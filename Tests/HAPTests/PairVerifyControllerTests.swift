// swiftlint:disable force_try
@testable import HAP
import XCTest
import Crypto

class PairVerifyControllerTests: XCTestCase {
    static var allTests: [(String, (PairVerifyControllerTests) -> () throws -> Void)] {
        return [
            ("test", test),
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
        ]
    }

    func test() {
        let device = Device(bridgeInfo: .init(name: "Test", serialNumber: "00090"),
                            setupCode: "123-44-321",
                            storage: MemoryStorage(),
                            accessories: [])

        let username = "hubba hubba".data(using: .utf8)!
        let pairingPrivateKey = Curve25519.Signing.PrivateKey()
        device.add(pairing: Pairing(identifier: username,
                                    publicKey: pairingPrivateKey.publicKey.rawRepresentation,
                                    role: .admin))

        let controller = PairVerifyController(device: device)
        // these are the client's keys for this verify session
        let clientPrivateKey = Curve25519.KeyAgreement.PrivateKey()

        let serverPublicKey: Data
        let encryptionKey: SymmetricKey
        let session: PairVerifyController.Session

        do {
            // Client -> Server: public key
            let request: PairTagTLV8 = [
                (.state, Data(bytes: [PairVerifyStep.startRequest.rawValue])),
                (.publicKey, clientPrivateKey.publicKey.rawRepresentation)
            ]
            let resultOuter: PairTagTLV8
            do {
                (resultOuter, session) = try controller.startRequest(request)
            } catch {
                return XCTFail("startRequest failed: \(error)")
            }

            // Server -> Client: encrypted(username, signature), public key
            // swiftlint:disable:next identifier_name
            guard let serverPublicKey_ = resultOuter[.publicKey],
                let encryptedData = resultOuter[.encryptedData] else {
                return XCTFail("Response is incomplete")
            }

            let sharedSecret = try! clientPrivateKey.sharedSecretFromKeyAgreement(
                with: .init(rawRepresentation: serverPublicKey_))

            XCTAssertEqual(sharedSecret, session.sharedSecret)

            encryptionKey = sharedSecret.hkdfDerivedSymmetricKey(
                using: SHA512.self,
                salt: "Pair-Verify-Encrypt-Salt".data(using: .utf8)!,
                sharedInfo: "Pair-Verify-Encrypt-Info".data(using: .utf8)!,
                outputByteCount: 32)

            let msg02 = try! ChaChaPoly.Nonce(data: Data(count: 4) + "PV-Msg02".data(using: .utf8)!)
            let plaintext = try! ChaChaPoly.open(
                ChaChaPoly.SealedBox(nonce: msg02,
                                     ciphertext: encryptedData.dropLast(16),
                                     tag: encryptedData.suffix(16)),
                using: encryptionKey)

            guard let resultInner: PairTagTLV8 = try? decode(plaintext),
                let username = resultInner[.identifier],
                let signature = resultInner[.signature] else {
                return XCTFail("Couldn't decode response")
            }
            let material = serverPublicKey_ + username + clientPrivateKey.publicKey.rawRepresentation
            if !device.publicKey.isValidSignature(signature, for: material) {
                return XCTFail("Invalid signature")
            }

            XCTAssertEqual(device.identifier, String(data: username, encoding: .utf8))
            serverPublicKey = serverPublicKey_
        }

        do {
            // Client -> Server: encrypted(username, signature)
            let material = clientPrivateKey.publicKey.rawRepresentation + username + serverPublicKey
            let signature = try! pairingPrivateKey.signature(for: material)
            let requestInner: PairTagTLV8 = [
                (.identifier, username),
                (.signature, signature)
            ]
            let msg03 = try! ChaChaPoly.Nonce(data: Data(count: 4) + "PV-Msg03".data(using: .utf8)!)
            let box = try! ChaChaPoly.seal(encode(requestInner), using: encryptionKey, nonce: msg03)
            let resultOuter: PairTagTLV8 = [
                (.encryptedData, box.ciphertext + box.tag)
            ]
            do {
                _ = try controller.finishRequest(resultOuter, session)
            } catch {
                return XCTFail("finishRequest failed: \(error)")
            }
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
