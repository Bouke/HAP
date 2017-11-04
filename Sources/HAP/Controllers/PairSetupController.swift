import func Evergreen.getLogger
import Foundation
import HKDF
import SRP

fileprivate let logger = getLogger("hap.controllers.pair-setup")

class PairSetupController {
    struct Session {
        let server: SRP.Server
    }
    enum Error: Swift.Error {
        case invalidParameters
        case invalidPairingMethod
        case couldNotDecryptMessage
        case couldNotDecodeMessage
        case couldNotSign
        case couldNotEncrypt
    }

    let device: Device
    public init(device: Device) {
        self.device = device
    }

    func startRequest(_ data: PairTagTLV8, _ session: Session) throws -> PairTagTLV8 {
        guard let method = data[.pairingMethod]?.first.flatMap({ PairingMethod(rawValue: $0) }) else {
            throw Error.invalidParameters
        }
        // TODO: according to spec, this should be `method == .pairSetup`
        guard method == .default else {
            throw Error.invalidPairingMethod
        }

        let (salt, serverPublicKey) = session.server.getChallenge()

        logger.info("Pair setup started")
        logger.debug("<-- s \(salt.hex)")
        logger.debug("<-- B \(serverPublicKey.hex)")

        let result: PairTagTLV8 = [
            .state: Data(bytes: [PairSetupStep.startResponse.rawValue]),
            .publicKey: serverPublicKey,
            .salt: salt
            ]
        return result
    }

    func verifyRequest(_ data: PairTagTLV8, _ session: Session) -> PairTagTLV8? {
        guard let clientPublicKey = data[.publicKey], let clientKeyProof = data[.proof] else {
            logger.warning("Invalid parameters")
            return nil
        }

        logger.debug("--> A \(clientPublicKey.hex)")
        logger.debug("--> M \(clientKeyProof.hex)")

        guard let serverKeyProof = try? session.server.verifySession(publicKey: clientPublicKey,
                                                                     keyProof: clientKeyProof) else {
            logger.warning("Invalid PIN")
            let result: PairTagTLV8 = [
                .state: Data(bytes: [PairSetupStep.verifyResponse.rawValue]),
                .error: Data(bytes: [PairError.authenticationFailed.rawValue])
            ]
            return result
        }

        logger.debug("<-- HAMK \(serverKeyProof.hex)")

        let result: PairTagTLV8 = [
            .state: Data(bytes: [PairSetupStep.verifyResponse.rawValue]),
            .proof: serverKeyProof
        ]
        return result
    }

    func keyExchangeRequest(_ data: PairTagTLV8, _ session: Session) throws -> PairTagTLV8 {
        guard let encryptedData = data[.encryptedData] else {
            throw Error.invalidParameters
        }

        let encryptionKey = deriveKey(algorithm: .sha512,
                                      seed: session.server.sessionKey!,
                                      info: "Pair-Setup-Encrypt-Info".data(using: .utf8),
                                      salt: "Pair-Setup-Encrypt-Salt".data(using: .utf8),
                                      count: 32)

        guard let plaintext = try? ChaCha20Poly1305.decrypt(cipher: encryptedData,
                                                            nonce: "PS-Msg05".data(using: .utf8)!,
                                                            key: encryptionKey) else {
            throw Error.couldNotDecryptMessage
        }

        guard let data: PairTagTLV8 = try? decode(plaintext) else {
            throw Error.couldNotDecodeMessage
        }

        guard let publicKey = data[.publicKey], let username = data[.identifier], let signatureIn = data[.signature] else {
            throw Error.invalidParameters
        }

        logger.debug("--> identifier \(String(data: username, encoding: .utf8)!)")
        logger.debug("--> public key \(publicKey.hex)")
        logger.debug("--> signature \(signatureIn.hex)")

        let hashIn = deriveKey(algorithm: .sha512,
                               seed: session.server.sessionKey!,
                               info: "Pair-Setup-Controller-Sign-Info".data(using: .utf8),
                               salt: "Pair-Setup-Controller-Sign-Salt".data(using: .utf8),
                               count: 32) +
            username +
            publicKey

        try Ed25519.verify(publicKey: publicKey, message: hashIn, signature: signatureIn)

        // At this point, the pairing has completed.
        device.pairings[username] = publicKey

        let hashOut = deriveKey(algorithm: .sha512,
                                seed: session.server.sessionKey!,
                                info: "Pair-Setup-Accessory-Sign-Info".data(using: .utf8),
                                salt: "Pair-Setup-Accessory-Sign-Salt".data(using: .utf8),
                                count: 32) +
            device.identifier.data(using: .utf8)! +
            device.publicKey

        guard let signatureOut = try? Ed25519.sign(privateKey: device.privateKey, message: hashOut) else {
            throw Error.couldNotSign
        }

        let resultInner: PairTagTLV8 = [
            .identifier: device.identifier.data(using: .utf8)!,
            .publicKey: device.publicKey,
            .signature: signatureOut
        ]

        logger.debug("<-- identifier \(self.device.identifier)")
        logger.debug("<-- public key \(self.device.publicKey.hex)")
        logger.debug("<-- signature \(signatureOut.hex)")
        logger.info("Pair setup completed")

        guard let encryptedResultInner = try? ChaCha20Poly1305.encrypt(message: encode(resultInner), nonce: "PS-Msg06".data(using: .utf8)!, key: encryptionKey) else {
            throw Error.couldNotEncrypt
        }

        let resultOuter: PairTagTLV8 = [
            .state: Data(bytes: [PairSetupStep.keyExchangeResponse.rawValue]),
            .encryptedData: encryptedResultInner
        ]
        return resultOuter
    }
}
