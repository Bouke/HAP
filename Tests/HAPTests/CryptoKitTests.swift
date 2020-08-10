// swiftlint:disable identifier_name force_cast function_body_length type_body_length line_length force_try
#if canImport(CryptoKit)
import CryptoKit
import Cryptor
@testable import HAP
import HKDF
import SRP
import XCTest

@available(macOS 10.15, *)
class CryptoKitTests: XCTestCase {

    let mySecret = Data(hex: "e0c0fa3b7da99fc893adc83feef61a0a7f529fe083a889f7ff404f73182bce59")!
    let myPublic = Data(hex: "c67ae350f5b3cca448837d7b7113a48c15da9be235fb2146dd48c1620e198832")!
    let otherSecret = Data(hex: "3f3465028bfd4288539ca19368168700953f219b989254882d07924abfda0949")!
    let otherPublic = Data(hex: "2c75efb94b3d96954d20dac6cc107cd78a703a022d55927c6728f1255ed39547")!
    let encryptionKey = Data(hex: "fc47f33641dba5cc153aef27b8fe45b3c2e674f346468eaf06e53fa9544f4a87")!
    let sharedSecret = Data(hex: "a7676523ea9deff107987d51f7bb5c0c6289554b11e89f3901d05507df2c4827")!
    let cipher = Data(hex: "9818bd6064b0a7a99ef8f054e1567af19d2cd7daf1cdfa58458bb4")!
    let username = "hubba hubba"

    func testGenerateSecret() {
        guard let secret = Keys.generateSecret() else {
            XCTFail("Unable to generate Secret")
            return
        }
        print(secret.hex)
        XCTAssertEqual(secret.count, 32, "Secret is not 256 bits long")
    }

    func testPublic() {
        let sd = Keys.SD_public(secretKey: mySecret)
        XCTAssertEqual(myPublic.hex, sd?.hex, "Public key does not match")
    }

    func testSharedSecret() {
        let ck = Keys.CK_sharedSecret(mySecret, otherPublicKey: otherPublic)
        XCTAssertEqual(ck?.hex, sharedSecret.hex, "Shared secret did not match")
    }

    func testDeriveSha512() {
        guard let ckSharedSecret = Keys.sharedSecret(mySecret, otherPublicKey: otherPublic) else {
            return XCTFail("CryptoKit Unable to create shared secret")
        }
        let info = "Pair-Verify-Encrypt-Info".data(using: .utf8)!
        let salt = "Pair-Verify-Encrypt-Salt".data(using: .utf8)!

        let ck = Keys.deriveSha512(seed: ckSharedSecret,
                                   info: info,
                                   salt: salt,
                                   count: 32)

        let hkdf = HKDF.deriveKey(algorithm: .sha512, seed: sharedSecret, info: info, salt: salt, count: 32)

        XCTAssertEqual(ck.hex, hkdf.hex, "Encryption Key did not match")
    }

    func testEncrypt() {
        let nonce = "PV-Msg02".data(using: .utf8)!

        let symKey = SymmetricKey(data: encryptionKey)
        guard let ckCipher = try? ChaCha20Poly1305.CK_encrypt(message: username.data(using: .utf8)!,
                                                              nonce: nonce,
                                                              key: symKey) else {
            return XCTFail("CryptoKit Couldn't encrypt")
        }
        XCTAssertEqual(cipher.hex, ckCipher.hex, "Encoding does not match")
    }

    func testDecrypt() {
        let nonce = "PV-Msg02".data(using: .utf8)!

        let info = "Pair-Verify-Encrypt-Info".data(using: .utf8)!
        let salt = "Pair-Verify-Encrypt-Salt".data(using: .utf8)!

        let sharedSecret = Keys.sharedSecret(otherSecret, otherPublicKey: myPublic)!

        let key = Keys.deriveSha512(seed: sharedSecret,
                                    info: info,
                                    salt: salt,
                                    count: 32)

        let decryptKey = key as! SymmetricKey
        guard let message = try? ChaCha20Poly1305.CK_decrypt(cipher: cipher,
                                                             nonce: nonce,
                                                             key: decryptKey) else {
            return XCTFail("CryptoKit Couldn't decrypt")
        }

        XCTAssertEqual(String(data: message, encoding: .utf8), username)
    }

    func testSign() {
        let keys = Ed25519.CK_generateSignKeypair() // these are the client's keys
        let buffer = Data(hex: "0d0086707542af59d8a62123455257e9f45b349501f46cad0e5f6ded6aab98")!

        let xs = try! Ed25519.CK_sign(privateKey: keys.privateKey, message: buffer)
        let verified: Bool
         do {
             try Ed25519.CK_verify(publicKey: keys.publicKey, message: buffer, signature: xs)
             verified = true
         } catch {
             verified = false
         }
         XCTAssertTrue(verified, "CryptoKit not verified Signature")
    }

    func testCreateAuthenticator() {
        let setupCode = "123-44-321"

        let username = "Pair-Setup"
        let testSalt = "b1bd375e4dd1bf8aabf06466c441053a".data(using: .utf8)!

        let t0 = Date()
        let (salt, verificationKey) = Authenticator.createSaltedVerificationKey(username: username,
                                                                                password: setupCode,
                                                                                salt: testSalt)
        let t1 = Date()
        _ = Authenticator(username: username, salt: salt, verificationKey: verificationKey)

        let t2 = Date()

        // Display timing
        print("create: \(-t1.distance(to: t0))")
        print("session: \(-t2.distance(to: t1))")
    }

    func testSRP() {
        let setupCode = "123-44-321"
        let group = Group.N3072
        let algorithm = Digest.Algorithm.sha512
        let username = "Pair-Setup"

        print("Start Authentication")

        let t0 = Date()

        let (salt, verificationKey) = createSaltedVerificationKey(username: username,
                                                                  password: setupCode,
                                                                  group: group,
                                                                  algorithm: algorithm)
        // HAP: Start Response M2
        let t1 = Date()

        let session = Authenticator(username: username,
                                    salt: salt,
                                    verificationKey: verificationKey)

        let t2 = Date()
        print("create: \(-t1.distance(to: t0))") // 5.2s, 5.0
        print("session: \(-t2.distance(to: t1))") // 10.5s, 9.7

        let (_, serverPublicKey) = session.getChallenge()

        // iOS: verify request M3

        print("Step M3")
        let iOSClient = SRP.Client(username: username, password: setupCode, group: group, algorithm: algorithm)
        let (_, clientPublicKey) = iOSClient.startAuthentication()

        let clientKeyProof = try! iOSClient.processChallenge(salt: salt,
                                                             publicKey: serverPublicKey)

        // HAP: Verify Response M4
        print("Step M4")

        let serverKeyProof = try! session.verifySession(publicKey: clientPublicKey,
                                                        keyProof: clientKeyProof)

        // iOS: verify
        print("Step M4 verify")

        do {
            try iOSClient.verifySession(keyProof: serverKeyProof)
        } catch {
            return XCTFail("Client verification failed")
        }

        // iOS: Request Generation M5
        // "b1cbb675e216321c31135b2b37fe8f321ed11f0a8cb0b634e0cf8a258a69dc4d7324b5a33480e43ac064ce87fdf443f123c352620c1dae1e219557422a5c483a"
        print("Step M5")

        let clientKeys = Ed25519.generateSignKeypair()
        let clientIdentifier = "H1:CC:AA:BB:00:88".data(using: .utf8)!

        let hashInM5 = HKDF.deriveKey(algorithm: .sha512,
                                      seed: session.server.sessionKey!,
                                      info: "Pair-Setup-Controller-Sign-Info".data(using: .utf8),
                                      salt: "Pair-Setup-Controller-Sign-Salt".data(using: .utf8),
                                      count: 32) +
            clientIdentifier +
            clientKeys.publicKey

        let signature = try! Ed25519.sign(privateKey: clientKeys.privateKey, message: hashInM5)

        let request: PairTagTLV8 = [
            (.publicKey, clientKeys.publicKey),
            (.identifier, clientIdentifier),
            (.signature, signature)
        ]

        let clientEncryptionKey = HKDF.deriveKey(algorithm: .sha512,
                                                 seed: session.server.sessionKey!,
                                                 info: "Pair-Setup-Encrypt-Info".data(using: .utf8),
                                                 salt: "Pair-Setup-Encrypt-Salt".data(using: .utf8),
                                                 count: 32)

        let encryptedData = try! ChaCha20Poly1305.encrypt(message: encode(request),
                                                          nonce: "PS-Msg05".data(using: .utf8)!,
                                                          key: clientEncryptionKey)

        // HAP: M5 verification, M6 response
        print("Step M5-M6")

        guard let plaintext = session.decrypt(encryptedData: encryptedData, nonce: "PS-Msg05") else {
            return XCTFail("Message decryption failed")
        }

        guard let data: PairTagTLV8 = try? decode(plaintext) else {
            return XCTFail("Message decode failed")
        }

        guard let resultPublicKey = data[.publicKey],
            let resultIdentifier = data[.identifier],
            let resultSignatureIn = data[.signature]
            else {
                return XCTFail("Message extraction failed")
        }

        print("Client ID \(String(data: resultIdentifier, encoding: .utf8)!)")

        let accessoryIdentifier = "88:00:88:BB:00:BB"

        let sig = session.verifyID(username: resultIdentifier,
                                   publicKey: resultPublicKey,
                                   signatureIn: resultSignatureIn,
                                   deviceID: accessoryIdentifier,
                                   devicePublicKey: clientKeys.publicKey,
                                   devicePrivateKey: clientKeys.privateKey)

        guard let signatureOut = sig else {
            return XCTFail("Unable to verify response or sign key exchange response")
        }

        let resultInner: PairTagTLV8 = [
            (.identifier, accessoryIdentifier.data(using: .utf8)!),
            (.publicKey, clientKeys.publicKey),
            (.signature, signatureOut)
        ]

        guard let encryptedResponse = session.encrypt(message: encode(resultInner), nonce: "PS-Msg06") else {
                return XCTFail("Encrypt key response failed")
        }

        // iOS: M6 verify

        print("Step M6 verify")

        let verifyText = try! ChaCha20Poly1305.decrypt(cipher: encryptedResponse,
                                                       nonce: "PS-Msg06".data(using: .utf8)!,
                                                       key: clientEncryptionKey)
        let response: PairTagTLV8 = try! decode(verifyText)
        let hashVerify = HKDF.deriveKey(algorithm: .sha512,
                                        seed: session.server.sessionKey!,
                                        info: "Pair-Setup-Accessory-Sign-Info".data(using: .utf8),
                                        salt: "Pair-Setup-Accessory-Sign-Salt".data(using: .utf8),
                                        count: 32) +
            response[.identifier]! +
            response[.publicKey]!
        do {
            try Ed25519.verify(publicKey: response[.publicKey]!, message: hashVerify, signature: response[.signature]!)
        } catch {
            return XCTFail("Client verification failed")
        }

        XCTAssertEqual(response[.publicKey]!.hex, clientKeys.publicKey.hex)
    }

    func testCrypt() {

        let sessionKey = Data(hex: "b1cbb675e216321c31135b2b37fe8f321ed11f0a8cb0b634e0cf8a258a69dc4d7324b5a33480e43ac064ce87fdf443f123c352620c1dae1e219557422a5c483a")!

        let clientKeys = Ed25519.generateSignKeypair()
        let clientIdentifier = "H1:CC:AA:BB:00:88".data(using: .utf8)!

        let hashInM5 = HKDF.deriveKey(algorithm: .sha512,
                                      seed: sessionKey,
                                      info: "Pair-Setup-Controller-Sign-Info".data(using: .utf8),
                                      salt: "Pair-Setup-Controller-Sign-Salt".data(using: .utf8),
                                      count: 32) +
            clientIdentifier +
            clientKeys.publicKey

        let signature = try! Ed25519.sign(privateKey: clientKeys.privateKey, message: hashInM5)

        let request: PairTagTLV8 = [
            (.publicKey, clientKeys.publicKey),
            (.identifier, clientIdentifier),
            (.signature, signature)
        ]

        let clientEncryptionKey = HKDF.deriveKey(algorithm: .sha512,
                                                 seed: sessionKey,
                                                 info: "Pair-Setup-Encrypt-Info".data(using: .utf8),
                                                 salt: "Pair-Setup-Encrypt-Salt".data(using: .utf8),
                                                 count: 32)

        let eKey = SymmetricKey(data: clientEncryptionKey)
        let encryptedData = try! ChaCha20Poly1305.CK_encrypt(message: encode(request),
                                                             nonce: "PS-Msg05".data(using: .utf8)!,
                                                             key: eKey)

        let xKey = eKey
        guard let plaintext = try? ChaCha20Poly1305.CK_decrypt(cipher: encryptedData,
                                                               nonce: "PS-Msg05".data(using: .utf8)!,
                                                               key: xKey) else {
                                                                return XCTFail("Message decryption failed")
        }

        guard let data: PairTagTLV8 = try? decode(plaintext) else {
            return XCTFail("Message decode failed")
        }

        guard let resultPublicKey = data[.publicKey],
            let resultIdentifier = data[.identifier],
            let resultSignatureIn = data[.signature]
            else {
                return XCTFail("Message extraction failed")
        }

        XCTAssertTrue(resultPublicKey.hex == clientKeys.publicKey.hex, "CryptoKit not matching Signature")
        XCTAssertTrue(resultIdentifier.hex == clientIdentifier.hex, "CryptoKit not matching Signature")
        XCTAssertTrue(resultSignatureIn.hex == signature.hex, "CryptoKit not matching Signature")
    }
}
#endif
