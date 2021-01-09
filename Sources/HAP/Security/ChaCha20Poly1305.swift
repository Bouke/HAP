// swiftlint:disable identifier_name line_length
import CLibSodium
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

    static func encrypt(message: Data, additional: Data = Data(), nonce: Data, key: Data) throws -> Data {
        let nonce = upgradeNonce(nonce)
        var cipher = Data(count: message.count + Int(crypto_aead_chacha20poly1305_ABYTES))
        let result = cipher.withUnsafeMutableBytes { c in
            message.withUnsafeBytes { m in
                additional.withUnsafeBytes { ad in
                    nonce.withUnsafeBytes { npub in
                        key.withUnsafeBytes { k in
                            crypto_aead_chacha20poly1305_ietf_encrypt(c.bindMemory(to: UInt8.self).baseAddress!,
                                                                      nil,
                                                                      m.bindMemory(to: UInt8.self).baseAddress!,
                                                                      UInt64(message.count),
                                                                      ad.bindMemory(to: UInt8.self).baseAddress!,
                                                                      UInt64(additional.count),
                                                                      nil,
                                                                      npub.bindMemory(to: UInt8.self).baseAddress!,
                                                                      k.bindMemory(to: UInt8.self).baseAddress!)
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

    static func encrypt(message: inout ByteBuffer, additional: ByteBufferView, nonce: Data, key: Data, cipher: inout ByteBuffer) throws {
        let nonce = upgradeNonce(nonce)
        let messageLength = UInt64(message.readableBytes)
        cipher.reserveWritableCapacity(message.readableBytes + Int(crypto_aead_chacha20poly1305_ABYTES))
        let additionalLength = UInt64(additional.count)
        let cipherLength = UnsafeMutablePointer<UInt64>.allocate(capacity: 1)
        let result = cipher.withUnsafeMutableWritableBytes { c in
            message.withUnsafeMutableReadableBytes { m in
                additional.withUnsafeBytes { ad in
                    nonce.withUnsafeBytes { npub in
                        key.withUnsafeBytes { k in
                            crypto_aead_chacha20poly1305_ietf_encrypt(c.bindMemory(to: UInt8.self).baseAddress!,
                                                                      cipherLength,
                                                                      m.bindMemory(to: UInt8.self).baseAddress!,
                                                                      messageLength,
                                                                      ad.bindMemory(to: UInt8.self).baseAddress!,
                                                                      additionalLength,
                                                                      nil,
                                                                      npub.bindMemory(to: UInt8.self).baseAddress!,
                                                                      k.bindMemory(to: UInt8.self).baseAddress!)
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

    static func decrypt(cipher: Data, additional: Data = Data(), nonce: Data, key: Data) throws -> Data {
        let nonce = upgradeNonce(nonce)
        var message = Data(count: cipher.count - Int(crypto_aead_chacha20poly1305_ietf_ABYTES))
        let result = message.withUnsafeMutableBytes { m in
            cipher.withUnsafeBytes { c in
                additional.withUnsafeBytes { ad in
                    nonce.withUnsafeBytes { npub in
                        key.withUnsafeBytes { k in
                            crypto_aead_chacha20poly1305_ietf_decrypt(m.bindMemory(to: UInt8.self).baseAddress!,
                                                                      nil,
                                                                      nil,
                                                                      c.bindMemory(to: UInt8.self).baseAddress!,
                                                                      UInt64(cipher.count),
                                                                      ad.bindMemory(to: UInt8.self).baseAddress!,
                                                                      UInt64(additional.count),
                                                                      npub.bindMemory(to: UInt8.self).baseAddress!,
                                                                      k.bindMemory(to: UInt8.self).baseAddress!)
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

    static func decrypt(cipher: inout ByteBuffer, additional: inout ByteBuffer, nonce: Data, key: Data, message: inout ByteBuffer) throws {
        let nonce = upgradeNonce(nonce)
        message.reserveWritableCapacity(cipher.readableBytes - Int(crypto_aead_chacha20poly1305_ietf_ABYTES))
        let cipherLength = UInt64(cipher.readableBytes)
        let additionalLength = UInt64(additional.readableBytes)
        let messageLength = UnsafeMutablePointer<UInt64>.allocate(capacity: 1)
        let result = message.withUnsafeMutableWritableBytes { m in
            cipher.withUnsafeMutableReadableBytes { c in
                additional.withUnsafeMutableReadableBytes { ad in
                    nonce.withUnsafeBytes { npub in
                        key.withUnsafeBytes { k in
                            crypto_aead_chacha20poly1305_ietf_decrypt(m.bindMemory(to: UInt8.self).baseAddress!,
                                                                      messageLength,
                                                                      nil,
                                                                      c.bindMemory(to: UInt8.self).baseAddress!,
                                                                      cipherLength,
                                                                      ad.bindMemory(to: UInt8.self).baseAddress!,
                                                                      additionalLength,
                                                                      npub.bindMemory(to: UInt8.self).baseAddress!,
                                                                      k.bindMemory(to: UInt8.self).baseAddress!)
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
