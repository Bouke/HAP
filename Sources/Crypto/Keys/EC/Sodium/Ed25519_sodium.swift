import Foundation
import CLibSodium

extension Curve25519.Signing {
    struct SodiumCurve25519PrivateKeyImpl {
        var _privateKey: Data
        var _publicKey: Data

        init() {
            _publicKey = Data(count: Int(crypto_sign_PUBLICKEYBYTES))
            _privateKey = Data(count: Int(crypto_sign_SECRETKEYBYTES))
            let rc = _publicKey.withUnsafeMutableBytes { publicKeyPointer in
                _privateKey.withUnsafeMutableBytes { privateKeyPointer in
                    crypto_sign_keypair(publicKeyPointer, privateKeyPointer)
                }
            }

            precondition(rc == 0, "Could not generate keypair")
        }

        var publicKey: SodiumCurve25519PublicKeyImpl {
            return SodiumCurve25519PublicKeyImpl(self._publicKey)
        }

        var key: Data {
            return self._privateKey
        }

        init<D: ContiguousBytes>(rawRepresentation data: D) throws {
            _publicKey = Data(count: Int(crypto_sign_PUBLICKEYBYTES))
            _privateKey = Data(count: Int(crypto_sign_SECRETKEYBYTES))

            let rc : CInt = try data.withUnsafeBytes { seedPointer in
                guard seedPointer.count == crypto_sign_SEEDBYTES else {
                    throw CryptoKitError.incorrectKeySize
                }

                return _publicKey.withUnsafeMutableBytes { publicKeyPointer in
                    _privateKey.withUnsafeMutableBytes { privateKeyPointer in
                        crypto_sign_seed_keypair(publicKeyPointer,
                                                 privateKeyPointer,
                                                 seedPointer.bindMemory(to: UInt8.self).baseAddress!)
                    }
                }
            }

            guard rc == 0 else {
                throw CryptoKitError.underlyingCoreCryptoError(error: rc)
            }
        }

        var rawRepresentation: Data {
            return Data(self._privateKey.prefix(Int(crypto_sign_SEEDBYTES)))
        }
    }

    struct SodiumCurve25519PublicKeyImpl {
        var key: Data

        init<D: ContiguousBytes>(rawRepresentation: D) throws {
            self.key = try rawRepresentation.withUnsafeBytes { keyBytesPtr in
                guard keyBytesPtr.count == crypto_sign_PUBLICKEYBYTES else {
                    throw CryptoKitError.incorrectKeySize
                }
                return Data(keyBytesPtr)
            }
        }

        init(_ key: Data) {
            precondition(key.count == crypto_sign_PUBLICKEYBYTES)
            self.key = key
        }

        var rawRepresentation: Data {
            return key
        }
    }
}
