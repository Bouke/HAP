// swiftlint:disable force_try
@testable import HAP
import HKDF
import SRP
import XCTest
import Crypto

class PairSetupControllerTests: XCTestCase {
    static var allTests: [(String, (PairSetupControllerTests) -> () throws -> Void)] {
        return [
            ("test", test),
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests)
        ]
    }

    func test() {
        let clientIdentifier = "hubba hubba".data(using: .utf8)!
        let password = "123-44-321"
        let (salt, verificationKey) = createSaltedVerificationKey(username: "Pair-Setup",
                                                                  password: password,
                                                                  group: .N3072,
                                                                  algorithm: .sha512)
        let session = PairSetupController.Session(server: SRP.Server(username: "Pair-Setup",
                                                                     salt: salt,
                                                                     verificationKey: verificationKey,
                                                                     group: .N3072,
                                                                     algorithm: .sha512))
        let device = Device(bridgeInfo: .init(name: "Test", serialNumber: "00080"),
                            setupCode: .override(password),
                            storage: MemoryStorage(),
                            accessories: [])
        let controller = PairSetupController(device: device)
        let client = SRP.Client(username: "Pair-Setup", password: password, group: .N3072, algorithm: .sha512)
        let key = Curve25519.Signing.PrivateKey()

        let clientKeyProof: Data
        do {
            // Server -> Client: [salt, publicKey]
            let response = try! controller.startRequest([
                (.pairingMethod, Data(bytes: [PairingMethod.default.rawValue]))
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

        do {
            // Client -> Server: encrypted[username, publicKey, signature]
            let hashIn = deriveKey(algorithm: .sha512,
                                   seed: session.server.sessionKey!,
                                   info: "Pair-Setup-Controller-Sign-Info".data(using: .utf8),
                                   salt: "Pair-Setup-Controller-Sign-Salt".data(using: .utf8),
                                   count: 32) +
                clientIdentifier +
                key.publicKey.rawRepresentation
            let request: PairTagTLV8 = [
                (.publicKey, key.publicKey.rawRepresentation),
                (.identifier, clientIdentifier),
                (.signature, try! key.signature(for: hashIn))
            ]
            let encryptionKey = SymmetricKey(data: deriveKey(algorithm: .sha512,
                                                             seed: session.server.sessionKey!,
                                                             info: "Pair-Setup-Encrypt-Info".data(using: .utf8),
                                                             salt: "Pair-Setup-Encrypt-Salt".data(using: .utf8),
                                                             count: 32))
            let msg05 = try! ChaChaPoly.Nonce(data: Data(count: 4) + "PS-Msg05".data(using: .utf8)!)
            let sealedRequest = try! ChaChaPoly.seal(encode(request),
                                                     using: encryptionKey,
                                                     nonce: msg05)

            let requestEncrypted: PairTagTLV8 = [
                (.encryptedData, sealedRequest.ciphertext + sealedRequest.tag)
            ]
            let responseEncrypted = try! controller.keyExchangeRequest(requestEncrypted, session)

            // Server -> Client: encrypted[username, publicKey, signature]
            let msg06 = try! ChaChaPoly.Nonce(data: Data(count: 4) + "PS-Msg06".data(using: .utf8)!)
            let plaintext = try! ChaChaPoly.open(ChaChaPoly.SealedBox(nonce: msg06,
                                                                      ciphertext: responseEncrypted[.encryptedData]!.dropLast(16),
                                                                      tag: responseEncrypted[.encryptedData]!.suffix(16)),
                                                 using: encryptionKey)
            let response: PairTagTLV8 = try! decode(plaintext)
            let hashOut = deriveKey(algorithm: .sha512,
                                    seed: session.server.sessionKey!,
                                    info: "Pair-Setup-Accessory-Sign-Info".data(using: .utf8),
                                    salt: "Pair-Setup-Accessory-Sign-Salt".data(using: .utf8),
                                    count: 32) +
                response[.identifier]! +
                response[.publicKey]!
            let publicKey = try! Curve25519.Signing.PublicKey(rawRepresentation: response[.publicKey]!)
            XCTAssert(publicKey.isValidSignature(response[.signature]!, for: hashOut))
        }

        XCTAssertEqual(device.get(pairingWithIdentifier: clientIdentifier)?.publicKey, key.publicKey.rawRepresentation)
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
