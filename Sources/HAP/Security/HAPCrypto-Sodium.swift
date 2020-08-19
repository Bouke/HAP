import Foundation
import NIO

/*
extension Data: HAPSharedSecret, HAPSymmetricKey {

    @inlinable var data: Data {
        return self
    }

    @inlinable func base64EncodedString() -> String {
        return self.base64EncodedString(options: [])
    }
    public var hex: String {
        return self.reduce("") { $0 + String(format: "%02x", $1) }
    }
}
*/

#if !((os(macOS) && arch(arm64)) || NO_LIB_SODIUM)

import CLibSodium

extension HAPCrypto {
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
extension HAPCrypto {

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
extension HAPCrypto {
    internal static func SD_public(secretKey: Data) -> Data? {
        return crypto(crypto_scalarmult_curve25519_base,
                      Data(count: Int(crypto_scalarmult_curve25519_BYTES)),
                      secretKey)
    }
    internal static func SD_sharedSecret(_ secretKey: Data, otherPublicKey: Data) -> HAPSharedSecret? {
        return crypto(crypto_scalarmult,
                      Data(count: Int(crypto_scalarmult_BYTES)),
                      secretKey,
                      otherPublicKey)
    }
}
#else
extension HAPCrypto {
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
extension HAPCrypto {

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
extension HAPCrypto {
    internal static func SD_public(secretKey: Data) -> Data? {
        assertionFailure("libsodium unavailable")
        return nil
    }
    internal static func SD_sharedSecret(_ secretKey: Data, otherPublicKey: Data) -> HAPSharedSecret? {
        assertionFailure("libsodium unavailable")
        return nil
    }
}
#endif
