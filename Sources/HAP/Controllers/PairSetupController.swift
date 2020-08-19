import Crypto
import Logging
import Foundation
import SRP

fileprivate let logger = Logger(label: "hap.controllers.pair-setup")

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
        case couldNotVerify
        case couldNotEncrypt
        case alreadyPaired
        case alreadyPairing
        case invalidSetupState
        case authenticationFailed
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

        // If the accessory is already paired it must respond with
        // Error_Unavailable
        if device.pairingState == .paired {
            throw Error.alreadyPaired
        }

        // If the accessory has received more than 100 unsuccessful
        // authentication attempts it must respond with
        // Error_MaxTries
        // TODO

        // If the accessory is currently performing a Pair Setup operation with
        // a different controller it must respond with
        // Error_Busy
        if device.pairingState == .pairing {
            throw Error.alreadyPairing
        }

        // Notify listeners of the pairing event and record the paring state
        // swiftlint:disable:next force_try
        try! device.changePairingState(.pairing)

        let (salt, serverPublicKey) = session.server.getChallenge()

        logger.info("Pair setup started")
        logger.debug("<-- s \(salt.hex)")
        logger.debug("<-- B \(serverPublicKey.hex)")

        let result: PairTagTLV8 = [
            (.state, Data([PairSetupStep.startResponse.rawValue])),
            (.publicKey, serverPublicKey),
            (.salt, salt)
        ]
        return result
    }

    func verifyRequest(_ data: PairTagTLV8, _ session: Session) throws -> PairTagTLV8? {
        guard let clientPublicKey = data[.publicKey], let clientKeyProof = data[.proof] else {
            logger.warning("Invalid parameters")
            throw Error.invalidSetupState
        }

        logger.debug("--> A \(clientPublicKey.hex)")
        logger.debug("--> M \(clientKeyProof.hex)")

        guard let serverKeyProof = try? session.server.verifySession(publicKey: clientPublicKey,
                                                                     keyProof: clientKeyProof)
            else {
                logger.warning("Invalid PIN")
                throw Error.authenticationFailed
        }

        logger.debug("<-- HAMK \(serverKeyProof.hex)")

        let result: PairTagTLV8 = [
            (.state, Data([PairSetupStep.verifyResponse.rawValue])),
            (.proof, serverKeyProof)
        ]
        return result
    }

    func keyExchangeRequest(_ data: PairTagTLV8, _ session: Session) throws -> PairTagTLV8 {
        guard let encryptedData = data[.encryptedData] else {
            throw Error.invalidParameters
        }

        let sessionKey = SymmetricKey(data: session.server.sessionKey!)

        let encryptionKey = HKDF<SHA512>.deriveKey(inputKeyMaterial: sessionKey,
                                                   salt: "Pair-Setup-Encrypt-Salt".data(using: .utf8)!,
                                                   info: "Pair-Setup-Encrypt-Info".data(using: .utf8)!,
                                                   outputByteCount: 32)

        let msg05 = try ChaChaPoly.Nonce(data: Data(count: 4) + "PS-Msg05".data(using: .utf8)!)
        let box = try ChaChaPoly.SealedBox(nonce: msg05, ciphertext: encryptedData.dropLast(16), tag: encryptedData.suffix(16))

        let plaintext = try ChaChaPoly.open(box, using: encryptionKey)

        guard let data: PairTagTLV8 = try? decode(plaintext) else {
            throw Error.couldNotDecodeMessage
        }

        guard let publicKey = data[.publicKey],
            let username = data[.identifier],
            let signatureIn = data[.signature]
            else {
                throw Error.invalidParameters
        }

        logger.debug("--> identifier \(String(data: username, encoding: .utf8)!)")
        logger.debug("--> public key \(publicKey.hex)")
        logger.debug("--> signature \(signatureIn.hex)")

        let hashInKey = HKDF<SHA512>.deriveKey(inputKeyMaterial: sessionKey,
                                               salt: "Pair-Setup-Controller-Sign-Salt".data(using: .utf8)!,
                                               info: "Pair-Setup-Controller-Sign-Info".data(using: .utf8)!,
                                               outputByteCount: 32)
        let hashIn = hashInKey.withUnsafeBytes({ Data($0) }) + username + publicKey

        let key = try Curve25519.Signing.PublicKey(rawRepresentation: publicKey)
        guard key.isValidSignature(signatureIn, for: hashIn) else {
            throw Error.couldNotVerify
        }

        let hashOutKey = HKDF<SHA512>.deriveKey(inputKeyMaterial: sessionKey,
                                                salt: "Pair-Setup-Accessory-Sign-Salt".data(using: .utf8)!,
                                                info: "Pair-Setup-Accessory-Sign-Info".data(using: .utf8)!,
                                                outputByteCount: 32)
        let hashOut = hashOutKey.withUnsafeBytes({ Data($0) }) + device.identifier.data(using: .utf8)! + device.publicKey

        let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: device.privateKey)
        guard let signatureOut = try? privateKey.signature(for: hashOut) else {
            throw Error.couldNotSign
        }

        let resultInner: PairTagTLV8 = [
            (.identifier, device.identifier.data(using: .utf8)!),
            (.publicKey, device.publicKey),
            (.signature, signatureOut)
        ]

        logger.debug("<-- identifier \(self.device.identifier)")
        logger.debug("<-- public key \(self.device.publicKey.hex)")
        logger.debug("<-- signature \(signatureOut.hex)")
        logger.info("Pair setup completed")

        let msg06 = try ChaChaPoly.Nonce(data: Data(count: 4) + "PS-Msg06".data(using: .utf8)!)
        let sealed = try ChaChaPoly.seal(encode(resultInner), using: encryptionKey, nonce: msg06)
        let encryptedResultInner = sealed.ciphertext + sealed.tag

        // At this point, the pairing has completed. The first controller is granted admin role.
        device.add(pairing: Pairing(identifier: username, publicKey: publicKey, role: .admin))

        let resultOuter: PairTagTLV8 = [
            (.state, Data([PairSetupStep.keyExchangeResponse.rawValue])),
            (.encryptedData, encryptedResultInner)
        ]
        return resultOuter
    }
}
