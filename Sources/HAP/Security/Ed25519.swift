import Foundation
import CLibSodium

class Ed25519 {
    enum Error: Swift.Error {
        case invalidSignature
        case couldNotSign
    }

    static func verify(publicKey: Data, message: Data, signature: Data) throws {
        guard signature.count == Int(crypto_sign_BYTES) else {
            throw Error.invalidSignature
        }
        guard signature.withUnsafeBytes({ pSignature in
            message.withUnsafeBytes { pMessage in
                publicKey.withUnsafeBytes { pPublicKey in
                    crypto_sign_verify_detached(pSignature, pMessage, UInt64(message.count), pPublicKey)
                }
            }
        }) == 0 else {
            throw Error.invalidSignature
        }
    }

    static func sign(privateKey: Data, message: Data) throws -> Data {
        var signature = Data(count: Int(crypto_sign_BYTES))
        guard signature.withUnsafeMutableBytes({ sig -> Int32 in
            message.withUnsafeBytes { m -> Int32 in
                privateKey.withUnsafeBytes { sk -> Int32 in
                    crypto_sign_detached(sig, nil, m, UInt64(message.count), sk)
                }
            }
        }) == 0 else {
            throw Error.couldNotSign
        }
        return signature
    }

    static func generateSignKeypair() -> (publicKey: Data, privateKey: Data) {
        var pk = Data(count: Int(crypto_sign_PUBLICKEYBYTES))
        var sk = Data(count: 64) // crypto_sign_SECRETKEYBYTES is not available
        precondition(pk.withUnsafeMutableBytes({ pk in
            sk.withUnsafeMutableBytes { sk in
                crypto_sign_keypair(pk, sk)
            }
        }) == 0, "Could not generate keypair")
        return (pk, sk)
    }
}
