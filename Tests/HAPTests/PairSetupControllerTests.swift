// swiftlint:disable force_try
import Crypto
@testable import HAP
import SRP
import XCTest

class PairSetupControllerTests: XCTestCase {
    static var allTests: [(String, (PairSetupControllerTests) -> () throws -> Void)] {
        [
            ("test", test),
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
        ]
    }

    func test() {
        let clientIdentifier = "hubba hubba".data(using: .utf8)!
        let password = "123-44-321"
        let (salt, verificationKey) = createSaltedVerificationKey(using: SHA512.self,
                                                                  group: .N3072,
                                                                  username: "Pair-Setup",
                                                                  password: password)
        let session = PairSetupController.Session(server: SRP.Server<SHA512>(username: "Pair-Setup",
                                                                             salt: salt,
                                                                             verificationKey: verificationKey,
                                                                             group: .N3072))
        let device = Device(bridgeInfo: .init(name: "Test", serialNumber: "00080"),
                            setupCode: .override(password),
                            storage: MemoryStorage(),
                            accessories: [])
        let controller = PairSetupController(device: device)
        let client = SRP.Client<SHA512>(username: "Pair-Setup", password: password, group: .N3072)
        let clientPrivateKey = Curve25519.Signing.PrivateKey()

        let clientKeyProof: Data
        do {
            // Server -> Client: [salt, publicKey]
            let response = try! controller.startRequest([
                (.pairingMethod, Data([PairingMethod.default.rawValue]))
            ], session)
            XCTAssertEqual(response.pairSetupStep, PairSetupStep.startResponse)
            XCTAssertEqual(response[.publicKey], session.server.publicKey)
            XCTAssertEqual(response[.salt], salt)
            clientKeyProof = try! client.processChallenge(salt: response[.salt]!,
                                                          publicKey: response[.publicKey]!)
        }

        do {
            // Client -> Server: [publicKey, keyProof]
            let response = try! controller.verifyRequest([(.publicKey, client.publicKey),
                                                          (.proof, clientKeyProof)],
                                                         session)
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.pairSetupStep, PairSetupStep.verifyResponse)

            // Server -> Client: [keyProof]
            let serverKeyProof = response![.proof]!
            try! client.verifySession(keyProof: serverKeyProof)
        }

        let sessionKey = SymmetricKey(data: session.server.sessionKey!)

        do {
            // Client -> Server: encrypted[username, publicKey, signature]
            let hashInKey = HKDF<SHA512>.deriveKey(inputKeyMaterial: sessionKey,
                                                   salt: "Pair-Setup-Controller-Sign-Salt".data(using: .utf8)!,
                                                   info: "Pair-Setup-Controller-Sign-Info".data(using: .utf8)!,
                                                   outputByteCount: 32)
            let hashIn = hashInKey.withUnsafeBytes({ Data($0) }) + clientIdentifier + clientPrivateKey.publicKey.rawRepresentation
            let request: PairTagTLV8 = [
                (.publicKey, clientPrivateKey.publicKey.rawRepresentation),
                (.identifier, clientIdentifier),
                (.signature, try! clientPrivateKey.signature(for: hashIn))
            ]

            let encryptionKey = HKDF<SHA512>.deriveKey(inputKeyMaterial: sessionKey,
                                                       salt: "Pair-Setup-Encrypt-Salt".data(using: .utf8)!,
                                                       info: "Pair-Setup-Encrypt-Info".data(using: .utf8)!,
                                                       outputByteCount: 32)
            let msg05 = try! ChaChaPoly.Nonce(data: Data(count: 4) + "PS-Msg05".data(using: .utf8)!)
            let requestSealed = try! ChaChaPoly.seal(encode(request), using: encryptionKey, nonce: msg05)
            let requestEncrypted: PairTagTLV8 = [
                (.encryptedData, requestSealed.ciphertext + requestSealed.tag)
            ]
            let responseEncrypted = try! controller.keyExchangeRequest(requestEncrypted, session)

            // Server -> Client: encrypted[username, publicKey, signature]
            let msg06 = try! ChaChaPoly.Nonce(data: Data(count: 4) + "PS-Msg06".data(using: .utf8)!)
            let responseSealed = try! ChaChaPoly.SealedBox(nonce: msg06,
                                                           ciphertext: responseEncrypted[.encryptedData]!.dropLast(16),
                                                           tag: responseEncrypted[.encryptedData]!.suffix(16))
            let plaintext = try! ChaChaPoly.open(responseSealed, using: encryptionKey)
            let response: PairTagTLV8 = try! decode(plaintext)
            let hashOutKey = HKDF<SHA512>.deriveKey(inputKeyMaterial: sessionKey,
                                                    salt: "Pair-Setup-Accessory-Sign-Salt".data(using: .utf8)!,
                                                    info: "Pair-Setup-Accessory-Sign-Info".data(using: .utf8)!,
                                                    outputByteCount: 32)
            let hashOut = hashOutKey.withUnsafeBytes({ Data($0) }) + response[.identifier]! + response[.publicKey]!

            let serverPublicKey = try! Curve25519.Signing.PublicKey(rawRepresentation: response[.publicKey]!)
            if !serverPublicKey.isValidSignature(response[.signature]!, for: hashOut) {
                XCTFail("Invalid server signature")
            }
        }

        XCTAssertEqual(device.get(pairingWithIdentifier: clientIdentifier)?.publicKey, clientPrivateKey.publicKey.rawRepresentation)
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
