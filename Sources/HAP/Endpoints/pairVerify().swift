import Foundation
import HTTP
import HKDF
import CommonCrypto
import CLibSodium
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap.pairVerify")

func pairVerify(device: Device) -> Application {
    //@todo where to place this? connection's context?
    let sk = generateRandomBytes(count: 32)
    let pk = { () -> Data in
        var pk = Data(count: 32)
        guard pk.withUnsafeMutableBytes({ pk in
            sk.withUnsafeBytes { sk in
                crypto_scalarmult_curve25519_base(pk, sk)
            }
        }) == 0 else {
            abort()
        }
        return pk
    }()

    //@todo move into connection's context
    var otherPublicKey: Data? = nil
    var sharedSecret: Data? = nil

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
            otherPublicKey = clientPublicKey

            sharedSecret = { () -> Data in
                var q = Data(count: 32)
                guard q.withUnsafeMutableBytes({ q -> Int32 in
                    sk.withUnsafeBytes { sk in
                        clientPublicKey.withUnsafeBytes { p in
                            crypto_scalarmult(q, sk, p)
                        }
                    }
                }) == 0 else {
                    abort()
                }
                return q
            }()

            let material = pk + device.identifier.data(using: .utf8)! + clientPublicKey
            let signature = try! Ed25519.sign(privateKey: device.privateKey, message: material)

            let resultInner: PairTagTLV8 = [
                .username: device.identifier.data(using: .utf8)!,
                .signature: signature
            ]
            logger.debug("startRequest result: \(resultInner)")

            let encryptionKey = HKDF.deriveKey(algorithm: .SHA512, seed: sharedSecret!, info: "Pair-Verify-Encrypt-Info".data(using: .utf8)!, salt: "Pair-Verify-Encrypt-Salt".data(using: .utf8)!, count: 32)

            guard let encryptedResultInner = try? ChaCha20Poly1305.encrypt(message: encode(resultInner), nonce: "PV-Msg02".data(using: .utf8)!, key: encryptionKey) else {
                logger.warning("Could not encrypt")
                return .badRequest
            }

            let resultOuter: PairTagTLV8 = [
                .sequence: Data(bytes: [PairVerifyStep.startResponse.rawValue]),
                .publicKey: pk,
                .encryptedData: encryptedResultInner
            ]

            let response = Response(status: .ok)
            response.headers["Content-Type"] = "application/pairing+tlv8"
            response.body = encode(resultOuter)
            return response

        case .finishRequest?:
            guard let encryptedData = data[.encryptedData] else {
                logger.warning("Invalid parameters")
                return .badRequest
            }

            let encryptionKey = HKDF.deriveKey(algorithm: .SHA512, seed: sharedSecret!, info: "Pair-Verify-Encrypt-Info".data(using: .utf8)!, salt: "Pair-Verify-Encrypt-Salt".data(using: .utf8)!, count: 32)

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

            let material = otherPublicKey! + username + pk
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

            let response = UpgradeResponse(cryptographer: Cryptographer(sharedKey: sharedSecret!))
            response.headers["Content-Type"] = "application/pairing+tlv8"
            response.body = encode(result)
            return response

        default: return .badRequest
        }
    }
}
