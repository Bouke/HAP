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

    let (salt, verificationKey) = createSaltedVerificationKey(username: "Pair-Setup", password: device.pin, group: group, alg: alg)
    let server = SRP.Server(group: group, alg: alg, salt: salt, username: "Pair-Setup", verificationKey: verificationKey)

    return { (connection, request) in
        guard let body = request.body, let data: PairTagTLV8 = try? decode(body) else { return .badRequest }

        switch PairSetupStep(rawValue: data[.sequence]![0]) {
        case .startRequest?:
            logger.info("Pair setup started")
            logger.debug("<-- B \(server.B)")
            logger.debug("<-- s \(salt)")

            let result: PairTagTLV8 = [
                .sequence: Data(bytes: [PairSetupStep.startResponse.rawValue]),
                .publicKey: server.B,
                .salt: salt,
            ]
            return Response(status: .ok, data: encode(result), mimeType: "application/pairing+tlv8")

        case .verifyRequest?:
            guard let A = data[.publicKey], let M = data[.proof] else {
                return .badRequest
            }

            logger.debug("--> A \(A)")
            logger.debug("--> M \(M)")

            guard let HAMK = try? server.verifySession(A: A, M: M) else {
                return .badRequest
            }

            logger.debug("<-- HAMK \(HAMK)")

            let result: PairTagTLV8 = [
                .sequence: Data(bytes: [PairSetupStep.verifyResponse.rawValue]),
                .proof: HAMK
            ]

            return Response(status: .ok, data: encode(result), mimeType: "application/pairing+tlv8")

        case .keyExchangeRequest?:
            guard let encryptedData = data[.encryptedData] else {
                return .badRequest
            }

            let encryptionKey = deriveKey(algorithm: .SHA512, seed: server.sessionKey!, info: "Pair-Setup-Encrypt-Info".data(using: .utf8)!, salt: "Pair-Setup-Encrypt-Salt".data(using: .utf8)!, count: 32)

            guard let plaintext = try? ChaCha20Poly1305(key: encryptionKey, nonce: "PS-Msg05".data(using: .utf8)!)!.decrypt(cipher: encryptedData) else {
                return .badRequest
            }

            guard let data: PairTagTLV8 = try? decode(plaintext) else {
                return .badRequest
            }

            guard let publicKey = data[.publicKey], let username = data[.username], let signatureIn = data[.signature] else {
                return .badRequest
            }

            logger.debug("--> username \(username) \(String(data: username, encoding: .utf8)!)")
            logger.debug("--> public key \(publicKey)")
            logger.debug("--> signature \(signatureIn)")

            let hashIn = deriveKey(algorithm: .SHA512, seed: server.sessionKey!,
                                   info: "Pair-Setup-Controller-Sign-Info".data(using: .utf8)!,
                                   salt: "Pair-Setup-Controller-Sign-Salt".data(using: .utf8)!, count: 32) +
                username +
                publicKey

            do {
                try Ed25519.verify(publicKey: publicKey, message: hashIn, signature: signatureIn)
            } catch {
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
                return .badRequest
            }

            let resultInner: PairTagTLV8 = [
                .username: device.identifier.data(using: .utf8)!,
                .publicKey: device.publicKey,
                .signature: signatureOut
            ]

            logger.debug("<-- username \(device.identifier)")
            logger.debug("<-- public key \(device.publicKey)")
            logger.debug("<-- signature \(signatureOut)")
            logger.info("Pair setup completed")

            guard let encryptor = ChaCha20Poly1305(key: encryptionKey, nonce: "PS-Msg06".data(using: .utf8)!), let encryptedResultInner = try? encryptor.encrypt(message: encode(resultInner)) else {
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
