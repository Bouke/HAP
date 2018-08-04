// swiftlint:disable force_try
import CLibSodium
import Cryptor
@testable import HAP
import HKDF
import XCTest

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
        let keys = Ed25519.generateSignKeypair() // these are the client's keys
        device.add(pairing: Pairing(identifier: username, publicKey: keys.publicKey, role: .admin))

        let controller = PairVerifyController(device: device)
        // these are the client's keys for this verify session
        let clientSecretKey = try! Data(bytes: Random.generate(byteCount: 32))
        let clientPublicKey = crypto(crypto_scalarmult_curve25519_base,
                                     Data(count: Int(crypto_scalarmult_curve25519_BYTES)),
                                     clientSecretKey)!
        let serverPublicKey: Data
        let encryptionKey: Data
        let session: PairVerifyController.Session

        do {
            // Client -> Server: public key
            let request: PairTagTLV8 = [
                (.state, Data(bytes: [PairVerifyStep.startRequest.rawValue])),
                (.publicKey, clientPublicKey)
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
            guard let sharedSecret = crypto(crypto_scalarmult,
                                            Data(count: Int(crypto_scalarmult_BYTES)),
                                            clientSecretKey,
                                            serverPublicKey_) else {
                return XCTFail("Couldn't generate shared secret")
            }
            XCTAssertEqual(sharedSecret.hex, session.sharedSecret.hex)
            // swiftlint:disable:next identifier_name
            let encryptionKey_ = HKDF.deriveKey(algorithm: .sha512,
                                                seed: sharedSecret,
                                                info: "Pair-Verify-Encrypt-Info".data(using: .utf8),
                                                salt: "Pair-Verify-Encrypt-Salt".data(using: .utf8),
                                                count: 32)
            guard let plainText = try? ChaCha20Poly1305.decrypt(cipher: encryptedData,
                                                                nonce: "PV-Msg02".data(using: .utf8)!,
                                                                key: encryptionKey_) else {
                return XCTFail("Couldn't decrypt response")
            }
            guard let resultInner: PairTagTLV8 = try? decode(plainText),
                let username = resultInner[.identifier],
                let signature = resultInner[.signature] else {
                return XCTFail("Couldn't decode response")
            }
            let material = serverPublicKey_ + username + clientPublicKey
            do {
                try Ed25519.verify(publicKey: device.publicKey, message: material, signature: signature)
            } catch {
                return XCTFail("Invalid signature")
            }
            XCTAssertEqual(device.identifier, String(data: username, encoding: .utf8))
            serverPublicKey = serverPublicKey_
            encryptionKey = encryptionKey_
        }

        do {
            // Client -> Server: encrypted(username, signature)
            let material = clientPublicKey + username + serverPublicKey
            guard let signature = try? Ed25519.sign(privateKey: keys.privateKey, message: material) else {
                return XCTFail("Couldn't sign")
            }
            let requestInner: PairTagTLV8 = [
                (.identifier, username),
                (.signature, signature)
            ]
            guard let cipher = try? ChaCha20Poly1305.encrypt(message: encode(requestInner),
                                                             nonce: "PV-Msg03".data(using: .utf8)!,
                                                             key: encryptionKey) else {
                return XCTFail("Couldn't encode")
            }
            let resultOuter: PairTagTLV8 = [
                (.encryptedData, cipher)
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
