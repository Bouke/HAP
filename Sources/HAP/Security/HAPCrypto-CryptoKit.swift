import Foundation
import NIO

#if canImport(CryptoKit)
import CryptoKit
/*
@available(macOS 10.15, iOS 13, *)
extension SharedSecret: HAPSharedSecret {
    var data: Data {
        return withUnsafeBytes {
            return Data($0)
        }
    }
    func base64EncodedString() -> String {
        return data.base64EncodedString()
    }
    public var hex: String {
        return data.hex
    }
}

@available(macOS 10.15, iOS 13, *)
extension SymmetricKey: HAPSymmetricKey {
    var data: Data {
        return withUnsafeBytes {
            return Data($0)
        }
    }
    public var hex: String {
        return data.hex
    }
}
*/

@available(OSX 10.15, iOS 13, *)
extension HAPCrypto {
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
@available(OSX 10.15, iOS 13, *)
extension HAPCrypto {
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
@available(macOS 10.15, iOS 13, *)
extension HAPCrypto {
    internal static func CK_public(secretKey: Data) -> Data? {
        do {
            let privateKey = try Curve25519.KeyAgreement.PrivateKey(rawRepresentation: secretKey)
            return privateKey.publicKey.rawRepresentation
        } catch {
            return nil
        }
    }
    internal static func CK_sharedSecret(_ secretKey: Data, otherPublicKey: Data) -> HAPSharedSecret? {
        do {
            let sharedPublicKey = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: otherPublicKey)
            let privateKey = try Curve25519.KeyAgreement.PrivateKey(rawRepresentation: secretKey)
            return try? privateKey.sharedSecretFromKeyAgreement(with: sharedPublicKey)
        } catch {
            return nil
        }
    }
}
#endif
