import Cryptor
import CLibSodium
import func Evergreen.getLogger
import Foundation
import HKDF
import SRP

fileprivate let logger = getLogger("hap.controllers.pair-verify")

class PairVerifyController {
    struct Session {
        let secretKey: Data
        let publicKey: Data
        let otherPublicKey: Data
        let sharedSecret: Data

        init?(clientPublicKey otherPublicKey: Data) {
            guard let secretKey = (try? Random.generate(byteCount: 32)).flatMap({ Data(bytes: $0) }),
                let publicKey = crypto(crypto_scalarmult_curve25519_base, Data(count: Int(crypto_scalarmult_curve25519_BYTES)), secretKey),
                let sharedSecret = crypto(crypto_scalarmult, Data(count: Int(crypto_scalarmult_BYTES)), secretKey, otherPublicKey)
                else {
                    return nil
            }
            self.secretKey = secretKey
            self.publicKey = publicKey
            self.otherPublicKey = otherPublicKey
            self.sharedSecret = sharedSecret
        }
    }

    enum Error: Swift.Error {
        case invalidParameters
        case couldNotSetupSession
        case couldNotEncrypt
        case couldNotDecrypt
        case couldNotDecode
        case noPublicKeyForUser
        case invalidSignature
    }

    let device: Device
    public init(device: Device) {
        self.device = device
    }

    func startRequest(_ data: PairTagTLV8) throws -> (PairTagTLV8, Session) {
        guard let clientPublicKey = data[.publicKey], clientPublicKey.count == 32 else {
            throw Error.invalidParameters
        }

        guard let session = Session(clientPublicKey: clientPublicKey) else {
            throw Error.couldNotSetupSession
        }

        let material = session.publicKey + device.identifier.data(using: .utf8)! + clientPublicKey
        let signature = try Ed25519.sign(privateKey: device.privateKey, message: material)

        let resultInner: PairTagTLV8 = [
            .identifier: device.identifier.data(using: .utf8)!,
            .signature: signature
        ]
        logger.debug("startRequest result: \(resultInner)")

        let encryptionKey = HKDF.deriveKey(algorithm: .sha512,
                                           seed: session.sharedSecret,
                                           info: "Pair-Verify-Encrypt-Info".data(using: .utf8),
                                           salt: "Pair-Verify-Encrypt-Salt".data(using: .utf8),
                                           count: 32)

        guard let encryptedResultInner = try? ChaCha20Poly1305.encrypt(message: encode(resultInner), nonce: "PV-Msg02".data(using: .utf8)!, key: encryptionKey) else {
            throw Error.couldNotEncrypt
        }

        let resultOuter: PairTagTLV8 = [
            .state: Data(bytes: [PairVerifyStep.startResponse.rawValue]),
            .publicKey: session.publicKey,
            .encryptedData: encryptedResultInner
        ]
        logger.debug("startRequest encrypted result: \(resultOuter)")
        return (resultOuter, session)
    }

    func finishRequest(_ data: PairTagTLV8, _ session: Session) throws -> PairTagTLV8 {
        guard let encryptedData = data[.encryptedData] else {
            throw Error.invalidParameters
        }

        let encryptionKey = HKDF.deriveKey(algorithm: .sha512,
                                           seed: session.sharedSecret,
                                           info: "Pair-Verify-Encrypt-Info".data(using: .utf8),
                                           salt: "Pair-Verify-Encrypt-Salt".data(using: .utf8),
                                           count: 32)

        guard let plaintext = try? ChaCha20Poly1305.decrypt(cipher: encryptedData, nonce: "PV-Msg03".data(using: .utf8)!, key: encryptionKey) else {
            throw Error.couldNotDecrypt
        }

        guard let data: PairTagTLV8 = try? decode(plaintext) else {
            throw Error.couldNotDecode
        }

        guard let username = data[.identifier], let signatureIn = data[.signature] else {
            throw Error.invalidParameters
        }

        logger.debug("--> username \(String(data: username, encoding: .utf8)!)")
        logger.debug("--> signature \(signatureIn.hex)")

        guard let publicKey = device.pairings[username] else {
            throw Error.noPublicKeyForUser
        }
        logger.debug("--> public key \(publicKey.hex)")

        let material = session.otherPublicKey + username + session.publicKey
        do {
            try Ed25519.verify(publicKey: publicKey, message: material, signature: signatureIn)
        } catch {
            throw Error.invalidSignature
        }

        logger.info("Pair verify completed")
        let result: PairTagTLV8 = [
            .state: Data(bytes: [PairVerifyStep.finishResponse.rawValue])
        ]
        return result
    }
}
