import Cryptor
import Foundation
import NIO
import func HKDF.deriveKey

/* 

 protocol HAPSharedSecret {
     func base64EncodedString() -> String
     var hex: String { get }
 }
 protocol HAPSymmetricKey {
     var data: Data { get }
     var hex: String { get }
 }

 */

protocol HAPCryptoProtocol {
    
    static func verify(publicKey: Data, message: Data, signature: Data) throws
    static func sign(privateKey: Data, message: Data) throws -> Data
    static func generateSignKeypair() -> (publicKey: Data, privateKey: Data)

    static func encrypt(message: Data, additional: Data, nonce: Data, key: HAPSymmetricKey) throws -> Data
    static func decrypt(cipher: Data, additional: Data, nonce: Data, key: HAPSymmetricKey) throws -> Data
    static func encrypt(message: inout ByteBuffer, additional: ByteBufferView, nonce: Data, key: HAPSymmetricKey, cipher: inout ByteBuffer) throws
    static func decrypt(cipher: inout ByteBuffer, additional: inout ByteBuffer, nonce: Data, key: HAPSymmetricKey, message: inout ByteBuffer) throws

    static func generateSecret() -> Data?
    static func `public`(secretKey: Data) -> Data?
    static func sharedSecret(_ secretKey: Data, otherPublicKey: Data) -> HAPSharedSecret?

}

enum HAPCrypto: HAPCryptoProtocol {
    enum Error: Swift.Error {
        case couldNotDecrypt
        case couldNotEncrypt
        case invalidSignature
        case couldNotSign

    }

    internal static func upgradeNonce(_ nonce: Data) -> Data {
        switch nonce.count {
        case 12: return nonce
        case 8: return Data(count: 4) + nonce
        default: abort()
        }
    }
}

#if canImport(CryptoKit)
import CryptoKit

extension HAPCrypto {

    @inlinable
    static func verify(publicKey: Data, message: Data, signature: Data) throws {
        if #available(macOS 10.15, iOS 13, *) {
            try CK_verify(publicKey: publicKey, message: message, signature: signature)
        } else {
            try SD_verify(publicKey: publicKey, message: message, signature: signature)
        }
    }

    @inlinable
    static func sign(privateKey: Data, message: Data) throws -> Data {
        if #available(macOS 10.15, iOS 13, *) {
            return try CK_sign(privateKey: privateKey, message: message)
        } else {
            return try SD_sign(privateKey: privateKey, message: message)
        }
    }

    @inlinable
    static func generateSignKeypair() -> (publicKey: Data, privateKey: Data) {
        if #available(macOS 10.15, iOS 13, *) {
            return CK_generateSignKeypair()
        } else {
            return SD_generateSignKeypair()
        }
    }
}
extension HAPCrypto {

    @inlinable
    static func encrypt(message: Data, additional: Data = Data(), nonce: Data, key: HAPSymmetricKey) throws -> Data {
        if #available(macOS 10.15, iOS 13, *) {
            return try CK_encrypt(message: message, nonce: nonce, key: symmetricKey(key))
        }
        #if os(macOS) && arch(arm64)
        assertionFailure("libsodium unavailable")
        return Data()
        #else
        return try SD_encrypt(message: message, additional: additional, nonce: nonce, key: key as! Data)
        #endif
    }

    @inlinable
    static func decrypt(cipher: Data, additional: Data = Data(), nonce: Data, key: HAPSymmetricKey) throws -> Data {
        if #available(macOS 10.15, iOS 13, *) {
            return try CK_decrypt(cipher: cipher, nonce: nonce, key: symmetricKey(key))
        }
        #if os(macOS) && arch(arm64)
        assertionFailure("libsodium unavailable")
        return Data()
        #else
        return try SD_decrypt(cipher: cipher, additional: additional, nonce: nonce, key: key as! Data)
        #endif
    }

    @inlinable
    static func encrypt(message: inout ByteBuffer, additional: ByteBufferView, nonce: Data, key: HAPSymmetricKey, cipher: inout ByteBuffer) throws {
        if #available(macOS 10.15, iOS 13, *) {
            try CK_encrypt(message: &message, additional: additional, nonce: nonce, key: symmetricKey(key), cipher: &cipher)
            return
        }
        #if os(macOS) && arch(arm64)
            assertionFailure("libsodium unavailable")
        #else
        try SD_encrypt(message: &message, additional: additional, nonce: nonce, key: key as! Data, cipher: &cipher)
        #endif
    }

    @inlinable
    static func decrypt(cipher: inout ByteBuffer, additional: inout ByteBuffer, nonce: Data, key: HAPSymmetricKey, message: inout ByteBuffer) throws {

        if #available(macOS 10.15, iOS 13, *) {
            try CK_decrypt(cipher: &cipher, additional: &additional, nonce: nonce, key: symmetricKey(key), message: &message)
            return
        }
        #if os(macOS) && arch(arm64)
            assertionFailure("libsodium unavailable")
        #else
        try SD_decrypt(cipher: &cipher, additional: &additional, nonce: nonce, key: key as! Data, message: &message)
        #endif
    }

    @available(macOS 10.15, iOS 13, *)
    private static func symmetricKey(_ key: HAPSymmetricKey) -> SymmetricKey {
        if let symmetricKey = key as? SymmetricKey {
            return symmetricKey
        } else {
            return SymmetricKey(data: key as! Data)
        }
    }
}
extension HAPCrypto {
    @inlinable
    static func generateSecret() -> Data? {
        if #available(macOS 10.15, iOS 13, *) {
            return Curve25519.KeyAgreement.PrivateKey().rawRepresentation
        } else {
            return (try? Random.generate(byteCount: 32)).flatMap({ Data($0) })
        }
    }

    @inlinable
    static func `public`(secretKey: Data) -> Data? {
        if #available(macOS 10.15, iOS 13, *) {
            return CK_public(secretKey: secretKey)
        }
        return SD_public(secretKey: secretKey)
    }

    @inlinable
    static func sharedSecret(_ secretKey: Data, otherPublicKey: Data) -> HAPSharedSecret? {
        if #available(macOS 10.15, iOS 13, *) {
            return CK_sharedSecret(secretKey, otherPublicKey: otherPublicKey)
        }
        return SD_sharedSecret(secretKey, otherPublicKey: otherPublicKey)
    }

    @inlinable
    static func deriveSha512(
        seed: HAPSharedSecret,
        info: Data,
        salt: Data,
        count: Int) -> HAPSymmetricKey {
        if #available(macOS 10.15, iOS 13, *) {
            if let sharedSecret = seed as? SharedSecret {
                return sharedSecret.hkdfDerivedSymmetricKey(
                    using: SHA512.self,
                    salt: salt,
                    sharedInfo: info,
                    outputByteCount: count)
            }
        }

        return deriveKey(algorithm: .sha512, seed: seed as! Data, info: info, salt: salt, count: count)
    }
}
#else // No CryptoKit
extension HAPCrypto {

    @inlinable
    static func verify(publicKey: Data, message: Data, signature: Data) throws {
        try SD_verify(publicKey: publicKey, message: message, signature: signature)
    }

    @inlinable
    static func sign(privateKey: Data, message: Data) throws -> Data {
        return try SD_sign(privateKey: privateKey, message: message)
    }

    @inlinable
    static func generateSignKeypair() -> (publicKey: Data, privateKey: Data) {
        return SD_generateSignKeypair()
    }
}
extension HAPCrypto {
    @inlinable
    static func generateSecret() -> Data? {
        return (try? Random.generate(byteCount: 32)).flatMap({ Data($0) })
    }

    @inlinable
    static func `public`(secretKey: Data) -> Data? {
        return SD_public(secretKey: secretKey)
    }

    @inlinable
    static func sharedSecret(_ secretKey: Data, otherPublicKey: Data) -> HAPSharedSecret? {
        return SD_sharedSecret(secretKey, otherPublicKey: otherPublicKey)
    }

    @inlinable
    static func deriveSha512(
        seed: HAPSharedSecret,
        info: Data,
        salt: Data,
        count: Int) -> HAPSymmetricKey {
        return deriveKey(algorithm: .sha512, seed: seed as! Data, info: info, salt: salt, count: count)
    }
}
#endif
