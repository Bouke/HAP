import Foundation
import HKDF
import Cryptor
import SRP
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap.pairSetup")

func pairSetup(device: Device) -> Application {
    let group = Group.N3072
    let algorithm = Digest.Algorithm.sha512

    let username = "Pair-Setup"
    let (salt, verificationKey) = createSaltedVerificationKey(username: username,
                                                              password: device.pin,
                                                              group: group,
                                                              algorithm: algorithm)
    let server = SRP.Server(username: username,
                            salt: salt,
                            verificationKey: verificationKey,
                            group: group,
                            algorithm: algorithm)

    return { (connection, request) in
        var body = Data()
        guard let _ = try? request.readAllData(into: &body), let data: PairTagTLV8 = try? decode(body) else { return .badRequest }

        switch PairSetupStep(rawValue: data[.sequence]![0]) {
        case .startRequest?:
            let (salt, serverPublicKey) = server.getChallenge()

            logger.info("Pair setup started")
            logger.debug("<-- B \(salt.hex)")
            logger.debug("<-- s \(serverPublicKey.hex)")

            let result: PairTagTLV8 = [
                .sequence: Data(bytes: [PairSetupStep.startResponse.rawValue]),
                .publicKey: serverPublicKey,
                .salt: salt,
            ]
            return Response(status: .ok, data: encode(result), mimeType: "application/pairing+tlv8")

        case .verifyRequest?:
            guard let clientPublicKey = data[.publicKey], let clientKeyProof = data[.proof] else {
                logger.warning("Invalid parameters")
                return .badRequest
            }

            logger.debug("--> A \(clientPublicKey.hex)")
            logger.debug("--> M \(clientKeyProof.hex)")

            guard let serverKeyProof = try? server.verifySession(publicKey: clientPublicKey,
                                                                 keyProof: clientKeyProof) else {
                logger.warning("Invalid PIN")
                let result: PairTagTLV8 = [
                    .sequence: Data(bytes: [PairSetupStep.verifyResponse.rawValue]),
                    .errorCode: Data(bytes: [PairError.authenticationFailed.rawValue])
                ]
                return Response(status: .ok, data: encode(result), mimeType: "application/pairing+tlv8")
            }

            logger.debug("<-- HAMK \(serverKeyProof.hex)")

            let result: PairTagTLV8 = [
                .sequence: Data(bytes: [PairSetupStep.verifyResponse.rawValue]),
                .proof: serverKeyProof
            ]

            return Response(status: .ok, data: encode(result), mimeType: "application/pairing+tlv8")

        case .keyExchangeRequest?:
            guard let encryptedData = data[.encryptedData] else {
                logger.warning("Invalid parameters")
                return .badRequest
            }

            let encryptionKey = deriveKey(algorithm: .sha512,
                                          seed: server.sessionKey!,
                                          info: "Pair-Setup-Encrypt-Info".data(using: .utf8),
                                          salt: "Pair-Setup-Encrypt-Salt".data(using: .utf8),
                                          count: 32)
            
            guard let plaintext = try? ChaCha20Poly1305.decrypt(cipher: encryptedData,
                                                                nonce: "PS-Msg05".data(using: .utf8)!,
                                                                key: encryptionKey) else {
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

            let hashIn = deriveKey(algorithm: .sha512, seed: server.sessionKey!,
                                   info: "Pair-Setup-Controller-Sign-Info".data(using: .utf8),
                                   salt: "Pair-Setup-Controller-Sign-Salt".data(using: .utf8),
                                   count: 32) +
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

            let hashOut = deriveKey(algorithm: .sha512, seed: server.sessionKey!,
                                    info: "Pair-Setup-Accessory-Sign-Info".data(using: .utf8),
                                    salt: "Pair-Setup-Accessory-Sign-Salt".data(using: .utf8),
                                    count: 32) +
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
