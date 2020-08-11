// swiftlint:disable identifier_name line_length no_grouping_extension force_cast
import Foundation
import NIO

class ChaCha20Poly1305 {
    enum Error: Swift.Error {
        case couldNotDecrypt, couldNotEncrypt
    }

    private static func upgradeNonce(_ nonce: Data) -> Data {
        switch nonce.count {
        case 12: return nonce
        case 8: return Data(count: 4) + nonce
        default: abort()
        }
    }
}

#if canImport(CryptoKit)
import CryptoKit

extension ChaCha20Poly1305 {

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

#else  // No CryptoKit

extension ChaCha20Poly1305 {

    @inlinable
    static func encrypt(message: Data, additional: Data = Data(), nonce: Data, key: HAPSymmetricKey) throws -> Data {
        return try SD_encrypt(message: message, additional: additional, nonce: nonce, key: key as! Data)
    }

    @inlinable
    static func decrypt(cipher: Data, additional: Data = Data(), nonce: Data, key: HAPSymmetricKey) throws -> Data {
        return try SD_decrypt(cipher: cipher, additional: additional, nonce: nonce, key: key as! Data)
    }

    @inlinable
    static func encrypt(message: inout ByteBuffer, additional: ByteBufferView, nonce: Data, key: HAPSymmetricKey, cipher: inout ByteBuffer) throws {
        try SD_encrypt(message: &message, additional: additional, nonce: nonce, key: key as! Data, cipher: &cipher)
    }

    @inlinable
    static func decrypt(cipher: inout ByteBuffer, additional: inout ByteBuffer, nonce: Data, key: HAPSymmetricKey, message: inout ByteBuffer) throws {
        try SD_decrypt(cipher: &cipher, additional: &additional, nonce: nonce, key: key as! Data, message: &message)
    }
}
#endif

#if !(os(macOS) && arch(arm64))
import CLibSodium

extension ChaCha20Poly1305 {

    internal static func SD_encrypt(message: Data, additional: Data = Data(), nonce: Data, key: Data) throws -> Data {
        let nonce = upgradeNonce(nonce)
        var cipher = Data(count: message.count + Int(crypto_aead_chacha20poly1305_ABYTES))
        let result = cipher.withUnsafeMutableBytes { c in
            message.withUnsafeBytes { m in
                additional.withUnsafeBytes { ad in
                    nonce.withUnsafeBytes { npub in
                        key.withUnsafeBytes { k in
                            crypto_aead_chacha20poly1305_ietf_encrypt(c, nil, m, UInt64(message.count), ad, UInt64(additional.count), nil, npub, k)
                        }
                    }
                }
            }
        }
        guard result == 0 else {
            throw Error.couldNotEncrypt
        }
        return cipher
    }

    internal static func SD_encrypt(message: inout ByteBuffer, additional: ByteBufferView, nonce: Data, key: Data, cipher: inout ByteBuffer) throws {
        let nonce = upgradeNonce(nonce)
        let messageLength = UInt64(message.readableBytes)
        cipher.reserveWritableCapacity(message.readableBytes + Int(crypto_aead_chacha20poly1305_ABYTES))
        let additionalLength = UInt64(additional.count)
        let cipherLength = UnsafeMutablePointer<UInt64>.allocate(capacity: 1)
        let result = cipher.withUnsafeMutableWritableBytes { (cBuffer: UnsafeMutableRawBufferPointer) -> Int32 in
            let cPointer = cBuffer.baseAddress!.bindMemory(to: UInt8.self, capacity: 1)
            return message.withUnsafeMutableReadableBytes { (mBuffer: UnsafeMutableRawBufferPointer) -> Int32 in
                let mPointer = UnsafePointer(mBuffer.baseAddress!.bindMemory(to: UInt8.self, capacity: 1))
                return additional.withUnsafeBytes { (adBuffer: UnsafeRawBufferPointer) -> Int32 in
                    let adPointer = adBuffer.baseAddress!.bindMemory(to: UInt8.self, capacity: 1)
                    return nonce.withUnsafeBytes { (npub: UnsafePointer<UInt8>) -> Int32 in
                        key.withUnsafeBytes { (k: UnsafePointer<UInt8>) -> Int32 in
                            crypto_aead_chacha20poly1305_ietf_encrypt(cPointer, cipherLength, mPointer, messageLength, adPointer, additionalLength, nil, npub, k)
                        }
                    }
                }
            }
        }
        guard result == 0 else {
            throw Error.couldNotEncrypt
        }
        cipher.moveWriterIndex(forwardBy: Int(cipherLength.pointee))
    }

    internal static func SD_decrypt(cipher: Data, additional: Data = Data(), nonce: Data, key: Data) throws -> Data {
        let nonce = upgradeNonce(nonce)
        var message = Data(count: cipher.count - Int(crypto_aead_chacha20poly1305_ietf_ABYTES))
        let result = message.withUnsafeMutableBytes { (m: UnsafeMutablePointer<UInt8>) -> Int32 in
            cipher.withUnsafeBytes { (c: UnsafePointer<UInt8>) -> Int32 in
                additional.withUnsafeBytes { (ad: UnsafePointer<UInt8>) -> Int32 in
                    nonce.withUnsafeBytes { (npub: UnsafePointer<UInt8>) -> Int32 in
                        key.withUnsafeBytes { (k: UnsafePointer<UInt8>) -> Int32 in
                            crypto_aead_chacha20poly1305_ietf_decrypt(m, nil, nil, c, UInt64(cipher.count), ad, UInt64(additional.count), npub, k)
                        }
                    }
                }
            }
        }
        guard result == 0 else {
            throw Error.couldNotDecrypt
        }
        return message
    }

    internal static func SD_decrypt(cipher: inout ByteBuffer, additional: inout ByteBuffer, nonce: Data, key: Data, message: inout ByteBuffer) throws {
        let nonce = upgradeNonce(nonce)
        message.reserveWritableCapacity(cipher.readableBytes - Int(crypto_aead_chacha20poly1305_ietf_ABYTES))
        let cipherLength = UInt64(cipher.readableBytes)
        let additionalLength = UInt64(additional.readableBytes)
        let messageLength = UnsafeMutablePointer<UInt64>.allocate(capacity: 1)
        let result = message.withUnsafeMutableWritableBytes { (mBuffer: UnsafeMutableRawBufferPointer) -> Int32 in
            let mPointer = mBuffer.baseAddress!.bindMemory(to: UInt8.self, capacity: 1)
            return cipher.withUnsafeMutableReadableBytes { (cBuffer: UnsafeMutableRawBufferPointer) -> Int32 in
                let cPointer = UnsafePointer(cBuffer.baseAddress!.bindMemory(to: UInt8.self, capacity: 1))
                return additional.withUnsafeMutableReadableBytes { (adBuffer: UnsafeMutableRawBufferPointer) -> Int32 in
                    let adPointer = UnsafePointer(adBuffer.baseAddress!.bindMemory(to: UInt8.self, capacity: 1))
                    return nonce.withUnsafeBytes { (npub: UnsafePointer<UInt8>) -> Int32 in
                        key.withUnsafeBytes { (k: UnsafePointer<UInt8>) -> Int32 in
                            crypto_aead_chacha20poly1305_ietf_decrypt(mPointer, messageLength, nil, cPointer, cipherLength, adPointer, additionalLength, npub, k)
                        }
                    }
                }
            }
        }
        guard result == 0 else {
            throw Error.couldNotDecrypt
        }
        message.moveWriterIndex(forwardBy: Int(messageLength.pointee))
    }
}
#else
extension ChaCha20Poly1305 {

    internal static func SD_encrypt(message: Data, additional: Data = Data(), nonce: Data, key: Data) throws -> Data {
        assertionFailure("libsodium unavailable")
        return Data()
    }

    internal static func SD_encrypt(message: inout ByteBuffer, additional: ByteBufferView, nonce: Data, key: Data, cipher: inout ByteBuffer) throws {
        assertionFailure("libsodium unavailable")
    }

    internal static func SD_decrypt(cipher: Data, additional: Data = Data(), nonce: Data, key: Data) throws -> Data {
        assertionFailure("libsodium unavailable")
        return Data()
    }

    internal static func SD_decrypt(cipher: inout ByteBuffer, additional: inout ByteBuffer, nonce: Data, key: Data, message: inout ByteBuffer) throws {
        assertionFailure("libsodium unavailable")
    }
}

#endif

#if canImport(CryptoKit)
@available(OSX 10.15, iOS 13, *)
extension ChaCha20Poly1305 {
    internal static func CK_encrypt(message: Data, additional: Data? = nil, nonce: Data, key: SymmetricKey) throws -> Data {
        do {
            let n = try ChaChaPoly.Nonce(data: upgradeNonce(nonce))
            if let ad = additional {
                let sealed = try ChaChaPoly.seal(message, using: key, nonce: n, authenticating: ad)
                return sealed.ciphertext + sealed.tag
            }
            let sealed = try ChaChaPoly.seal(message, using: key, nonce: n)
            return sealed.ciphertext + sealed.tag

        } catch {
            throw Error.couldNotEncrypt
        }
    }
    internal static func CK_decrypt(cipher: Data, additional: Data? = nil, nonce: Data, key: SymmetricKey) throws -> Data {

        do {
            let n = try ChaChaPoly.Nonce(data: upgradeNonce(nonce))
            let box = try ChaChaPoly.SealedBox(nonce: n, ciphertext: cipher.prefix(cipher.count - 16), tag: cipher.suffix(16))
            if let ad = additional {
                return try ChaChaPoly.open(box, using: key, authenticating: ad)
            }

            return try ChaChaPoly.open(box, using: key)

        } catch {
            throw Error.couldNotDecrypt
        }
    }

    internal static func CK_encrypt(message: inout ByteBuffer, additional: ByteBufferView, nonce: Data, key: SymmetricKey, cipher: inout ByteBuffer) throws {
        let nonce = upgradeNonce(nonce)
        let messageLength = message.readableBytes
        let ad = additional.withUnsafeBytes { Data($0) }
        if let message = message.getData(at: message.readerIndex, length: messageLength) {
            let data = try ChaCha20Poly1305.CK_encrypt(message: message, additional: ad, nonce: nonce, key: key)
            cipher.writeBytes(data)
            return
        } else {
            throw Error.couldNotEncrypt
        }
    }

    internal static func CK_decrypt(cipher: inout ByteBuffer, additional: inout ByteBuffer, nonce: Data, key: SymmetricKey, message: inout ByteBuffer) throws {

        let nonce = upgradeNonce(nonce)
        let cipherLength = cipher.readableBytes
        let additionalLength = additional.readableBytes
        let ad = additional.getData(at: additional.readerIndex, length: additionalLength)
        if let cipher = cipher.getData(at: cipher.readerIndex, length: cipherLength) {
            let data = try ChaCha20Poly1305.CK_decrypt(cipher: cipher, additional: ad, nonce: nonce, key: key)
            message.writeBytes(data)
            return
        } else {
            throw Error.couldNotDecrypt
        }
    }
}
#endif
