// swiftlint:disable identifier_name no_grouping_extension
import Foundation

#if canImport(CryptoKit)
import CryptoKit
#endif

class Ed25519 {
    enum Error: Swift.Error {
        case invalidSignature
        case couldNotSign
    }

    static func verify(publicKey: Data, message: Data, signature: Data) throws {
        if #available(macOS 10.15, iOS 13, *) {
            try CK_verify(publicKey: publicKey, message: message, signature: signature)
        } else {
            try SD_verify(publicKey: publicKey, message: message, signature: signature)
        }
    }

    static func sign(privateKey: Data, message: Data) throws -> Data {
        if #available(macOS 10.15, iOS 13, *) {
            return try CK_sign(privateKey: privateKey, message: message)
        } else {
            return try SD_sign(privateKey: privateKey, message: message)
        }
    }

    static func generateSignKeypair() -> (publicKey: Data, privateKey: Data) {
        if #available(macOS 10.15, iOS 13, *) {
            return CK_generateSignKeypair()
        } else {
            return SD_generateSignKeypair()
        }
    }
}

#if !(os(macOS) && arch(arm64))
import CLibSodium

extension Ed25519 {
    static func SD_verify(publicKey: Data, message: Data, signature: Data) throws {
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

    static func SD_sign(privateKey: Data, message: Data) throws -> Data {
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

    static func SD_generateSignKeypair() -> (publicKey: Data, privateKey: Data) {
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
#else
extension Ed25519 {
    static func SD_verify(publicKey: Data, message: Data, signature: Data) throws {
        assertionFailure("libsodium unavailable")
    }

    static func SD_sign(privateKey: Data, message: Data) throws -> Data {
        assertionFailure("libsodium unavailable")
        return Data()
    }

    static func SD_generateSignKeypair() -> (publicKey: Data, privateKey: Data) {
        assertionFailure("libsodium unavailable")
        return (Data(), Data())
    }

}
#endif

#if canImport(CryptoKit)

@available(OSX 10.15, iOS 13, *)
extension Ed25519 {
    static func CK_verify(publicKey pkData: Data, message: Data, signature: Data) throws {
        guard signature.count == 64,
            let publicKey = try? Curve25519.Signing.PublicKey(rawRepresentation: pkData) else {
            throw Error.invalidSignature
        }

        if !publicKey.isValidSignature(signature, for: message) {
            throw Error.invalidSignature
        }
    }

    static func CK_sign(privateKey pkData: Data, message: Data) throws -> Data {
        do {
            let privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: pkData)
            return try privateKey.signature(for: message)
        } catch {
            throw Error.couldNotSign
        }
    }

    static func CK_generateSignKeypair() -> (publicKey: Data, privateKey: Data) {
        let privateKey = Curve25519.Signing.PrivateKey()
        return(privateKey.publicKey.rawRepresentation, privateKey.rawRepresentation)
    }

}
#endif
