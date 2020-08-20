// swiftlint:disable no_grouping_extension implicit_return force_cast

import Cryptor
import Foundation
import func HKDF.deriveKey

protocol HAPSharedSecret {
    func base64EncodedString() -> String
    var hex: String { get }
}
protocol HAPSymmetricKey {
    var data: Data { get }
    var hex: String { get }
}

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

enum Keys {
    @inlinable
    static func sharedSecret(stringEncoded: String) -> HAPSharedSecret? {
        let data = Data(base64Encoded: stringEncoded)
        let secretKey = data!.prefix(32)
        let otherPublicKey = data!.suffix(32)
        return Keys.sharedSecret(secretKey, otherPublicKey: otherPublicKey)
    }
}

#if canImport(CryptoKit)

import CryptoKit

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

extension Keys {
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
extension Keys {
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

#if !(os(macOS) && arch(arm64))

import CLibSodium

extension Keys {
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
extension Keys {
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

#if canImport(CryptoKit)

@available(macOS 10.15, iOS 13, *)
extension Keys {
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

