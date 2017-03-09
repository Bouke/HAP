import Foundation
import HTTP
import HKDF
import Cryptor
import CLibSodium
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap.pairVerify")

struct Session {
    let secretKey: Data
    let publicKey: Data
    let otherPublicKey: Data
    let sharedSecret: Data
    
    init?(clientPublicKey otherPublicKey: Data) {
        let secretKey = Data(bytes: try! Random.generate(byteCount: 32))
        guard let publicKey = crypto(crypto_scalarmult_curve25519_base, Data(count: Int(crypto_scalarmult_curve25519_BYTES)), secretKey),
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

func pairVerify(device: Device) -> Application {
    return { (connection, request) in
        guard let body = request.body, let data: PairTagTLV8 = try? decode(body) else {
            logger.warning("Could not decode message")
            return .badRequest
        }

        switch PairVerifyStep(rawValue: data[.sequence]![0]) {
        case .startRequest?:
            logger.info("Pair verify started")

            guard let clientPublicKey = data[.publicKey], clientPublicKey.count == 32 else {
                logger.warning("Invalid parameters")
                return .badRequest
            }
            
            guard let session = Session(clientPublicKey: clientPublicKey) else {
                logger.error("Could not setup session")
                return .badRequest
            }

            let material = session.publicKey + device.identifier.data(using: .utf8)! + clientPublicKey
            let signature = try! Ed25519.sign(privateKey: device.privateKey, message: material)

            let resultInner: PairTagTLV8 = [
                .username: device.identifier.data(using: .utf8)!,
                .signature: signature
            ]
            logger.debug("startRequest result: \(resultInner)")

            let encryptionKey = HKDF.deriveKey(algorithm: .sha512,
                                               seed: session.sharedSecret,
                                               info: "Pair-Verify-Encrypt-Info".data(using: .utf8),
                                               salt: "Pair-Verify-Encrypt-Salt".data(using: .utf8),
                                               count: 32)

            guard let encryptedResultInner = try? ChaCha20Poly1305.encrypt(message: encode(resultInner), nonce: "PV-Msg02".data(using: .utf8)!, key: encryptionKey) else {
                logger.warning("Could not encrypt")
                return .badRequest
            }

            let resultOuter: PairTagTLV8 = [
                .sequence: Data(bytes: [PairVerifyStep.startResponse.rawValue]),
                .publicKey: session.publicKey,
                .encryptedData: encryptedResultInner
            ]

            connection.context["hap.pairVerify.session"] = session
            
            let response = Response(status: .ok)
            response.headers["Content-Type"] = "application/pairing+tlv8"
            response.body = encode(resultOuter)
            return response

        case .finishRequest?:
            guard let session = connection.context["hap.pairVerify.session"] as? Session else {
                logger.warning("No session")
                return .badRequest
            }
            
            guard let encryptedData = data[.encryptedData] else {
                logger.warning("Invalid parameters")
                return .badRequest
            }

            let encryptionKey = HKDF.deriveKey(algorithm: .sha512,
                                               seed: session.sharedSecret,
                                               info: "Pair-Verify-Encrypt-Info".data(using: .utf8),
                                               salt: "Pair-Verify-Encrypt-Salt".data(using: .utf8),
                                               count: 32)

            guard let plaintext = try? ChaCha20Poly1305.decrypt(cipher: encryptedData, nonce: "PV-Msg03".data(using: .utf8)!, key: encryptionKey) else {
                logger.warning("Could not decrypt message")
                return .badRequest
            }

            guard let data: PairTagTLV8 = try? decode(plaintext) else {
                logger.warning("Could not decode message")
                return .badRequest
            }

            guard let username = data[.username], let signatureIn = data[.signature] else {
                logger.warning("Invalid parameters")
                return .badRequest
            }

            logger.debug("--> username \(String(data: username, encoding: .utf8)!)")
            logger.debug("--> signature \(signatureIn.hex)")

            guard let publicKey = device.clients[username] else {
                logger.warning("No public key found for user")
                return .badRequest
            }
            logger.debug("--> public key \(publicKey.hex)")

            let material = session.otherPublicKey + username + session.publicKey
            do {
                try Ed25519.verify(publicKey: publicKey, message: material, signature: signatureIn)
            } catch {
                logger.warning("Could not verify signature")
                return .badRequest
            }

            logger.info("Pair verify completed")
            let result: PairTagTLV8 = [
                .sequence: Data(bytes: [PairVerifyStep.finishResponse.rawValue])
            ]

            let response = UpgradeResponse(cryptographer: Cryptographer(sharedKey: session.sharedSecret))
            response.headers["Content-Type"] = "application/pairing+tlv8"
            response.body = encode(result)
            return response

        default: return .badRequest
        }
    }
}
