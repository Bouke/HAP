import CLibSodium
import Foundation

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

    static func decrypt(cipher: Data, additional: Data = Data(), nonce: Data, key: Data) throws -> Data {
        let nonce = upgradeNonce(nonce)
        var message = Data(count: cipher.count - Int(crypto_aead_chacha20poly1305_ietf_ABYTES))
        let result = message.withUnsafeMutableBytes { m in
            cipher.withUnsafeBytes { c in
                additional.withUnsafeBytes { ad in
                    nonce.withUnsafeBytes { npub in
                        key.withUnsafeBytes { k in
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
}
