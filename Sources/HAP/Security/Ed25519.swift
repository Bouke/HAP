// swiftlint:disable identifier_name
import CLibSodium
import Foundation

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
                    crypto_sign_verify_detached(pSignature.bindMemory(to: UInt8.self).baseAddress!,
                                                pMessage.bindMemory(to: UInt8.self).baseAddress!,
                                                UInt64(message.count),
                                                pPublicKey.bindMemory(to: UInt8.self).baseAddress!)
                }
            }
        }) == 0 else {
            throw Error.invalidSignature
        }
    }

    static func sign(privateKey: Data, message: Data) throws -> Data {
        var signature = Data(count: Int(crypto_sign_BYTES))
        guard signature.withUnsafeMutableBytes({ sig in
            message.withUnsafeBytes { m in
                privateKey.withUnsafeBytes { sk in
                    crypto_sign_detached(sig.bindMemory(to: UInt8.self).baseAddress!,
                                         nil,
                                         m.bindMemory(to: UInt8.self).baseAddress!,
                                         UInt64(message.count),
                                         sk.bindMemory(to: UInt8.self).baseAddress!)
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
                crypto_sign_keypair(pk.bindMemory(to: UInt8.self).baseAddress!,
                                    sk.bindMemory(to: UInt8.self).baseAddress!)
            }
        }) == 0, "Could not generate keypair")
        return (pk, sk)
    }
}
