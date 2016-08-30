import Foundation
import HTTP
import HKDF
import CommonCrypto
import SRP
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap.pairSetup")

func pairSetup(device: Device) -> Application {
    let group = Group.N3072
    let alg = Digest.SHA512

    let username = "Pair-Setup"
    let (salt, verificationKey) = createSaltedVerificationKey(username: username, password: device.pin, group: group, alg: alg)
    let server = SRP.Server(group: group, alg: alg, salt: salt, username: username, verificationKey: verificationKey)

    return { (connection, request) in
        guard let body = request.body, let data: PairTagTLV8 = try? decode(body) else { return .badRequest }

        switch PairSetupStep(rawValue: data[.sequence]![0]) {
        case .startRequest?:
            logger.info("Pair setup started")
            logger.debug("<-- B \(server.B.hex)")
            logger.debug("<-- s \(salt.hex)")

            let result: PairTagTLV8 = [
                .sequence: Data(bytes: [PairSetupStep.startResponse.rawValue]),
                .publicKey: server.B,
                .salt: salt,
            ]
            return Response(status: .ok, data: encode(result), mimeType: "application/pairing+tlv8")

        case .verifyRequest?:
            guard let A = data[.publicKey], let M = data[.proof] else {
                logger.warning("Invalid parameters")
                return .badRequest
            }

            logger.debug("--> A \(A.hex)")
            logger.debug("--> M \(M.hex)")

            guard let HAMK = try? server.verifySession(A: A, M: M) else {
                logger.warning("Invalid PIN")
                return .badRequest
            }

            logger.debug("<-- HAMK \(HAMK.hex)")

            let result: PairTagTLV8 = [
                .sequence: Data(bytes: [PairSetupStep.verifyResponse.rawValue]),
                .proof: HAMK
            ]

            return Response(status: .ok, data: encode(result), mimeType: "application/pairing+tlv8")

        case .keyExchangeRequest?:
            guard let encryptedData = data[.encryptedData] else {
                logger.warning("Invalid parameters")
                return .badRequest
            }

            let encryptionKey = deriveKey(algorithm: .SHA512, seed: server.sessionKey!, info: "Pair-Setup-Encrypt-Info".data(using: .utf8)!, salt: "Pair-Setup-Encrypt-Salt".data(using: .utf8)!, count: 32)
            
            guard let plaintext = try? ChaCha20Poly1305.decrypt(cipher: encryptedData, nonce: "PS-Msg05".data(using: .utf8)!, key: encryptionKey) else {
//            guard let plaintext = try? ChaCha20Poly1305(key: encryptionKey, nonce: )!.decrypt(cipher: encryptedData) else {
                logger.warning("Could not decrypt message")
                return .badRequest
            }

            guard let data: PairTagTLV8 = try? decode(plaintext) else {
                logger.warning("Could not decode message")
                return .badRequest
            }

            guard let publicKey = data[.publicKey], let username = data[.username], let signatureIn = data[.signature] else {
                logger.warning("Invalid parameters")
                return .badRequest
            }

            logger.debug("--> username \(String(data: username, encoding: .utf8)!)")
            logger.debug("--> public key \(publicKey.hex)")
            logger.debug("--> signature \(signatureIn.hex)")

            let hashIn = deriveKey(algorithm: .SHA512, seed: server.sessionKey!,
                                   info: "Pair-Setup-Controller-Sign-Info".data(using: .utf8)!,
                                   salt: "Pair-Setup-Controller-Sign-Salt".data(using: .utf8)!, count: 32) +
                username +
                publicKey

            do {
                try Ed25519.verify(publicKey: publicKey, message: hashIn, signature: signatureIn)
            } catch {
                logger.warning("Invalid signature")
                return .badRequest
            }

            // At this point, the client has successfully verified.
            device.clients[username] = publicKey

            let hashOut = deriveKey(algorithm: .SHA512, seed: server.sessionKey!,
                                    info: "Pair-Setup-Accessory-Sign-Info".data(using: .utf8)!,
                                    salt: "Pair-Setup-Accessory-Sign-Salt".data(using: .utf8)!, count: 32) +
                device.identifier.data(using: .utf8)! +
                device.publicKey

            guard let signatureOut = try? Ed25519.sign(privateKey: device.privateKey, message: hashOut) else {
                logger.warning("Could not sign")
                return .badRequest
            }

            let resultInner: PairTagTLV8 = [
                .username: device.identifier.data(using: .utf8)!,
                .publicKey: device.publicKey,
                .signature: signatureOut
            ]

            logger.debug("<-- username \(device.identifier)")
            logger.debug("<-- public key \(device.publicKey.hex)")
            logger.debug("<-- signature \(signatureOut.hex)")
            logger.info("Pair setup completed")

            guard let encryptedResultInner = try? ChaCha20Poly1305.encrypt(message: encode(resultInner), nonce: "PS-Msg06".data(using: .utf8)!, key: encryptionKey) else {
//            guard let encryptor = ChaCha20Poly1305(key: encryptionKey, nonce: "PS-Msg06".data(using: .utf8)!), let encryptedResultInner = try? encryptor.encrypt(message: encode(resultInner)) else {
                logger.warning("Could not encrypt")
                return .badRequest
            }

            let resultOuter: PairTagTLV8 = [
                .sequence: Data(bytes: [PairSetupStep.keyExchangeResponse.rawValue]),
                .encryptedData: encryptedResultInner
            ]

            return Response(status: .ok, data: encode(resultOuter), mimeType: "application/pairing+tlv8")

        default: return .badRequest
        }
    }
}
