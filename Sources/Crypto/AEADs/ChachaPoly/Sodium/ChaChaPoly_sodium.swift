import CLibSodium
import Foundation

enum SodiumChaChaPolyImpl {
    static func encrypt<M: DataProtocol, AD: DataProtocol>(key: SymmetricKey, message: M, nonce: ChaChaPoly.Nonce?, authenticatedData: AD?) throws -> ChaChaPoly.SealedBox {
        guard key.bitCount == ChaChaPoly.keyBitsCount else {
            throw CryptoKitError.incorrectKeySize
        }
        let nonce = nonce ?? ChaChaPoly.Nonce()

        let ciphertext: Data
        let tag: Data
        if let ad = authenticatedData {
            (ciphertext, tag) = try SodiumAEAD.seal(message: message, key: key, nonce: nonce, authenticatedData: ad)
        } else {
            (ciphertext, tag) = try SodiumAEAD.seal(message: message, key: key, nonce: nonce, authenticatedData: [])
        }

        return try ChaChaPoly.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
    }

    static func decrypt<AD: DataProtocol>(key: SymmetricKey, ciphertext: ChaChaPoly.SealedBox, authenticatedData: AD?) throws -> Data {
        guard key.bitCount == ChaChaPoly.keyBitsCount else {
            throw CryptoKitError.incorrectKeySize
        }

        if let ad = authenticatedData {
            return try SodiumAEAD.open(ciphertext: ciphertext.ciphertext, key: key, nonce: ciphertext.nonce, tag: ciphertext.tag, authenticatedData: ad)
        } else {
            return try SodiumAEAD.open(ciphertext: ciphertext.ciphertext, key: key, nonce: ciphertext.nonce, tag: ciphertext.tag, authenticatedData: [])
        }
    }
}

/// An abstraction over a BoringSSL AEAD
@usableFromInline
enum SodiumAEAD {
    /// Seal a given message.
    static func seal<Plaintext: DataProtocol, Nonce: ContiguousBytes, AuthenticatedData: DataProtocol>(message: Plaintext, key: SymmetricKey, nonce: Nonce, authenticatedData: AuthenticatedData) throws -> (ciphertext: Data, tag: Data) {
        // Both fields are potentially discontiguous, so we need to check and flatten them.
        switch (message.regions.count, authenticatedData.regions.count) {
        case (1, 1):
            // Both data protocols are secretly contiguous.
            return try self.seal(contiguousMessage: message.regions.first!, key: key, nonce: nonce, contiguousAuthenticatedData: authenticatedData.regions.first!)
        case (1, _):
            // The authenticated data isn't contiguous: we make it so.
            return try self.seal(contiguousMessage: message.regions.first!, key: key, nonce: nonce, contiguousAuthenticatedData: Array(authenticatedData))
        case (_, 1):
            // The message isn't contiguous, make it so.
            return try self.seal(contiguousMessage: Array(message), key: key, nonce: nonce, contiguousAuthenticatedData: authenticatedData.regions.first!)
        case (_, _):
            // Neither are contiguous.
            return try self.seal(contiguousMessage: Array(message), key: key, nonce: nonce, contiguousAuthenticatedData: Array(authenticatedData))
        }
    }

    static func seal<Plaintext: ContiguousBytes, Nonce: ContiguousBytes, AuthenticatedData: ContiguousBytes>(contiguousMessage message: Plaintext, key: SymmetricKey, nonce: Nonce, contiguousAuthenticatedData authenticatedData: AuthenticatedData) throws -> (ciphertext: Data, tag: Data) {
        return try message.withUnsafeBytes { messagePointer in
            try authenticatedData.withUnsafeBytes { authenticatedDataPointer in
                try nonce.withUnsafeBytes { noncePointer in
                    try key.withUnsafeBytes { keyPointer in
                        try seal(plaintextPointer: messagePointer, keyPointer: keyPointer, noncePointer: noncePointer, authenticatedDataPointer: authenticatedDataPointer)
                    }
                }
            }
        }
    }

    static func seal(plaintextPointer: UnsafeRawBufferPointer, keyPointer: UnsafeRawBufferPointer, noncePointer: UnsafeRawBufferPointer, authenticatedDataPointer: UnsafeRawBufferPointer) throws -> (ciphertext: Data, tag: Data) {
        var ciphertext = Data(count: plaintextPointer.count)
        var tag = Data(count: Int(crypto_aead_chacha20poly1305_IETF_ABYTES))

        let rc = ciphertext.withUnsafeMutableBytes { ciphertextPointer in
            tag.withUnsafeMutableBytes { tagPointer in
                crypto_aead_chacha20poly1305_ietf_encrypt_detached(ciphertextPointer.bindMemory(to: UInt8.self).baseAddress!,
                                                                   tagPointer.bindMemory(to: UInt8.self).baseAddress!,
                                                                   nil,
                                                                   plaintextPointer.bindMemory(to: UInt8.self).baseAddress,
                                                                   UInt64(plaintextPointer.count),
                                                                   authenticatedDataPointer.bindMemory(to: UInt8.self).baseAddress,
                                                                   UInt64(authenticatedDataPointer.count),
                                                                   nil,
                                                                   noncePointer.bindMemory(to: UInt8.self).baseAddress!,
                                                                   keyPointer.bindMemory(to: UInt8.self).baseAddress!)
            }
        }

        guard rc == 0 else {
            throw CryptoKitError.underlyingCoreCryptoError(error: rc)
        }

        return (ciphertext, tag)
    }

    /// Open a given message.
    static func open<Nonce: ContiguousBytes, AuthenticatedData: DataProtocol>(ciphertext: Data, key: SymmetricKey, nonce: Nonce, tag: Data, authenticatedData: AuthenticatedData) throws -> Data {
        if authenticatedData.regions.count == 1 {
            return try self.openContiguous(ciphertext: ciphertext, key: key, nonce: nonce, tag: tag, authenticatedData: authenticatedData.regions.first!)
        } else {
            return try self.openContiguous(ciphertext: ciphertext, key: key, nonce: nonce, tag: tag, authenticatedData: Array(authenticatedData))
        }
    }

    static func openContiguous<Nonce: ContiguousBytes, AuthenticatedData: ContiguousBytes>(ciphertext: Data, key: SymmetricKey, nonce: Nonce, tag: Data, authenticatedData: AuthenticatedData) throws -> Data {
        var message = Data(count: ciphertext.count)

        let rc = message.withUnsafeMutableBytes { messagePointer in
            ciphertext.withUnsafeBytes { ciphertextPointer in
                tag.withUnsafeBytes { tagPointer in
                    authenticatedData.withUnsafeBytes { authenticatedDataPointer in
                        nonce.withUnsafeBytes { noncePointer in
                            key.withUnsafeBytes { keyPointer in
                                crypto_aead_chacha20poly1305_ietf_decrypt_detached(messagePointer.bindMemory(to: UInt8.self).baseAddress,
                                                                                   nil,
                                                                                   ciphertextPointer.bindMemory(to: UInt8.self).baseAddress!,
                                                                                   UInt64(ciphertext.count),
                                                                                   tagPointer.bindMemory(to: UInt8.self).baseAddress!,
                                                                                   authenticatedDataPointer.bindMemory(to: UInt8.self).baseAddress,
                                                                                   UInt64(authenticatedDataPointer.count),
                                                                                   noncePointer.bindMemory(to: UInt8.self).baseAddress!,
                                                                                   keyPointer.bindMemory(to: UInt8.self).baseAddress!)
                            }
                        }
                    }
                }
            }
        }

        guard rc == 0 else {
            throw CryptoKitError.underlyingCoreCryptoError(error: rc)
        }

        return message
    }
}
