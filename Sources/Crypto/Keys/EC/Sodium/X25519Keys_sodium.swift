import CLibSodium
import Foundation

extension Curve25519.KeyAgreement {
    @usableFromInline
    static let keySizeBytes = 32

    @usableFromInline
    struct SodiumCurve25519PublicKeyImpl {
        @usableFromInline
        var key: Data

        @inlinable
        init<D: ContiguousBytes>(rawRepresentation: D) throws {
            self.key = try rawRepresentation.withUnsafeBytes { dataPtr in
                guard dataPtr.count == Curve25519.KeyAgreement.keySizeBytes else {
                    throw CryptoKitError.incorrectKeySize
                }

                return Data(dataPtr)
            }
        }

        @usableFromInline
        init(_ key: Data) {
            self.key = key
        }

        @usableFromInline
        var rawRepresentation: Data {
            return self.key
        }
    }

    @usableFromInline
    struct SodiumCurve25519PrivateKeyImpl {
        var _privateKey: Data
        var _publicKey: Data

        var key: Data {
            return _privateKey
        }

        @usableFromInline
        var publicKey: SodiumCurve25519PublicKeyImpl {
            return SodiumCurve25519PublicKeyImpl(_publicKey)
        }

        init() {
            _publicKey = Data(count: Int(crypto_kx_PUBLICKEYBYTES))
            _privateKey = Data(count: Int(crypto_kx_SECRETKEYBYTES))
            let rc = _publicKey.withUnsafeMutableBytes { publicKeyPointer in
                _privateKey.withUnsafeMutableBytes { privateKeyPointer in
                    crypto_kx_keypair(publicKeyPointer.bindMemory(to: UInt8.self).baseAddress!,
                                      privateKeyPointer.bindMemory(to: UInt8.self).baseAddress!)
                }
            }

            precondition(rc == 0, "Could not generate keypair")
        }

//        init<D: ContiguousBytes>(rawRepresentation: D) throws {
//        }

        @usableFromInline
        func sharedSecretFromKeyAgreement(with publicKeyShare: SodiumCurve25519PublicKeyImpl) throws -> SharedSecret {
            var sharedSecret = Data(count: Int(crypto_scalarmult_BYTES))
            let rc: CInt = try sharedSecret.withUnsafeMutableBytes { sharedSecretPointer in
                try self._privateKey.withUnsafeBytes { privateKeyPointer in
                    try publicKeyShare.key.withUnsafeBytes { publicKeySharePointer in
                        guard publicKeySharePointer.count == crypto_kx_PUBLICKEYBYTES else {
                            throw CryptoKitError.incorrectKeySize
                        }

                        return crypto_scalarmult(sharedSecretPointer.bindMemory(to: UInt8.self).baseAddress!,
                                                 privateKeyPointer.bindMemory(to: UInt8.self).baseAddress!,
                                                 publicKeySharePointer.bindMemory(to: UInt8.self).baseAddress!)
                    }
                }
            }

            guard rc == 0 else {
                throw CryptoKitError.underlyingCoreCryptoError(error: rc)
            }

            return SharedSecret(ss: sharedSecret)
        }

        @usableFromInline
        var rawRepresentation: Data {
            return Data(self._privateKey.prefix(Int(crypto_kx_SEEDBYTES)))
        }

        /// Validates whether the passed x25519 key representation is valid.
        /// - Parameter rawRepresentation: The provided key representation. Expected to be a valid 32-bytes private key.
        static func validateX25519PrivateKeyData(rawRepresentation: UnsafeRawBufferPointer) throws {
            guard rawRepresentation.count == 32 else {
                throw CryptoKitError.incorrectKeySize
            }
        }
    }
}
