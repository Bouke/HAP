import Cryptor
import Logging
import Foundation
import HKDF
import SRP
import Crypto

fileprivate let logger = Logger(label: "hap.controllers.pair-verify")

class PairVerifyController {
    struct Session {
        let privateKey: Curve25519.KeyAgreement.PrivateKey
        let publicKey: Curve25519.KeyAgreement.PublicKey
        let clientPublicKey: Curve25519.KeyAgreement.PublicKey
        let sharedSecret: SharedSecret

        init(clientPublicKey: Curve25519.KeyAgreement.PublicKey) throws {
            self.privateKey = .init()
            self.publicKey = self.privateKey.publicKey
            self.clientPublicKey = clientPublicKey
            self.sharedSecret = try self.privateKey.sharedSecretFromKeyAgreement(with: clientPublicKey)
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

        let session = try Session(clientPublicKey: try Curve25519.KeyAgreement.PublicKey(rawRepresentation: clientPublicKey))

        let material = session.publicKey.rawRepresentation + device.identifier.data(using: .utf8)! + clientPublicKey
        let key = try Curve25519.Signing.PrivateKey(rawRepresentation: device.privateKey)
        let signature = try key.signature(for: material)

        let resultInner: PairTagTLV8 = [
            (.identifier, device.identifier.data(using: .utf8)!),
            (.signature, signature)
        ]
        logger.debug("startRequest result: \(resultInner)")

        let encryptionKey = HKDF.deriveKey(algorithm: .sha512,
                                           seed: session.sharedSecret.withUnsafeBytes { Data($0) },
                                           info: "Pair-Verify-Encrypt-Info".data(using: .utf8),
                                           salt: "Pair-Verify-Encrypt-Salt".data(using: .utf8),
                                           count: 32)

        let nonce = try ChaChaPoly.Nonce(data: Data(count: 4) + "PV-Msg02".data(using: .utf8)!)
        let symmetricKey = SymmetricKey(data: encryptionKey)
        let sealed = try ChaChaPoly.seal(encode(resultInner), using: symmetricKey, nonce: nonce)
        let encryptedResultInner = sealed.ciphertext + sealed.tag

        let resultOuter: PairTagTLV8 = [
            (.state, Data(bytes: [PairVerifyStep.startResponse.rawValue])),
            (.publicKey, session.publicKey.rawRepresentation),
            (.encryptedData, encryptedResultInner)
        ]
        logger.debug("startRequest encrypted result: \(resultOuter)")
        return (resultOuter, session)
    }

    func finishRequest(_ data: PairTagTLV8, _ session: Session) throws -> (PairTagTLV8, Pairing) {
        guard let encryptedData = data[.encryptedData] else {
            throw Error.invalidParameters
        }

        let encryptionKey = HKDF.deriveKey(algorithm: .sha512,
                                           seed: session.sharedSecret.withUnsafeBytes { Data($0) },
                                           info: "Pair-Verify-Encrypt-Info".data(using: .utf8),
                                           salt: "Pair-Verify-Encrypt-Salt".data(using: .utf8),
                                           count: 32)

        let nonce = try ChaChaPoly.Nonce(data: Data(count: 4) + "PV-Msg03".data(using: .utf8)!)
        let box = try ChaChaPoly.SealedBox(nonce: nonce, ciphertext: encryptedData.dropLast(16), tag: encryptedData.suffix(16))

        let plaintext = try ChaChaPoly.open(box, using: SymmetricKey(data: encryptionKey))

        guard let data: PairTagTLV8 = try? decode(plaintext) else {
            throw Error.couldNotDecode
        }

        guard let username = data[.identifier], let signatureIn = data[.signature] else {
            throw Error.invalidParameters
        }

        logger.debug("--> username \(String(data: username, encoding: .utf8)!)")
        logger.debug("--> signature \(signatureIn.hex)")

        guard let pairing = device.get(pairingWithIdentifier: username) else {
            throw Error.noPublicKeyForUser
        }
        logger.debug("--> public key \(pairing.publicKey.hex)")

        let material = session.clientPublicKey.rawRepresentation + username + session.publicKey.rawRepresentation
        guard
            let key = try? Curve25519.Signing.PublicKey(rawRepresentation: pairing.publicKey),
            key.isValidSignature(signatureIn, for: material) else {
            throw Error.invalidSignature
        }

        logger.info("Pair verify completed")
        let result: PairTagTLV8 = [
            (.state, Data(bytes: [PairVerifyStep.finishResponse.rawValue]))
        ]
        return (result, pairing)
    }
}
