// swiftlint:disable force_try
@testable import HAP
import HKDF
import SRP
import XCTest

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
        let keys = Ed25519.generateSignKeypair()

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
                keys.publicKey
            let request: PairTagTLV8 = [
                (.publicKey, keys.publicKey),
                (.identifier, clientIdentifier),
                (.signature, try! Ed25519.sign(privateKey: keys.privateKey, message: hashIn))
            ]
            let encryptionKey = deriveKey(algorithm: .sha512,
                                          seed: session.server.sessionKey!,
                                          info: "Pair-Setup-Encrypt-Info".data(using: .utf8),
                                          salt: "Pair-Setup-Encrypt-Salt".data(using: .utf8),
                                          count: 32)
            let requestEncrypted: PairTagTLV8 = [
                (.encryptedData, try! ChaCha20Poly1305.encrypt(message: encode(request),
                                                               nonce: "PS-Msg05".data(using: .utf8)!,
                                                               key: encryptionKey))
            ]
            let responseEncrypted = try! controller.keyExchangeRequest(requestEncrypted, session)

            // Server -> Client: encrypted[username, publicKey, signature]
            let plaintext = try! ChaCha20Poly1305.decrypt(cipher: responseEncrypted[.encryptedData]!,
                                                          nonce: "PS-Msg06".data(using: .utf8)!,
                                                          key: encryptionKey)
            let response: PairTagTLV8 = try! decode(plaintext)
            let hashOut = deriveKey(algorithm: .sha512,
                                    seed: session.server.sessionKey!,
                                    info: "Pair-Setup-Accessory-Sign-Info".data(using: .utf8),
                                    salt: "Pair-Setup-Accessory-Sign-Salt".data(using: .utf8),
                                    count: 32) +
                response[.identifier]! +
                response[.publicKey]!
            try! Ed25519.verify(publicKey: response[.publicKey]!, message: hashOut, signature: response[.signature]!)
        }

        XCTAssertEqual(device.get(pairingWithIdentifier: clientIdentifier)?.publicKey, keys.publicKey)
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
