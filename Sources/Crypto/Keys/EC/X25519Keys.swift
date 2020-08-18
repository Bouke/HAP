// Copyright (c) 2019 Apple Inc. and the SwiftCrypto project authors
// Licensed under Apache License v2.0
import Foundation

extension Curve25519 {
    public enum KeyAgreement {
        typealias Curve25519PrivateKeyImpl = Curve25519.KeyAgreement.SodiumCurve25519PrivateKeyImpl
        typealias Curve25519PublicKeyImpl = Curve25519.KeyAgreement.SodiumCurve25519PublicKeyImpl

        public struct PublicKey: ECPublicKey {
            fileprivate var baseKey: Curve25519PublicKeyImpl

            /// Initializes a Curve25519 Key for Key Agreement.
            ///
            /// - Parameter rawRepresentation: The data representation of the key
            /// - Returns: An initialized key if the data is valid.
            /// - Throws: Throws if the data is not a valid key.
            public init<D: ContiguousBytes>(rawRepresentation: D) throws {
                self.baseKey = try Curve25519PublicKeyImpl(rawRepresentation: rawRepresentation)
            }

            fileprivate init(baseKey: Curve25519PublicKeyImpl) {
                self.baseKey = baseKey
            }

            /// A data representation of the public key
            public var rawRepresentation: Data {
                return self.baseKey.rawRepresentation
            }

            var key: Data {
                return self.baseKey.key
            }

            private func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
                return try self.baseKey.key.withUnsafeBytes(body)
            }
        }

        public struct PrivateKey: ECPrivateKey, DiffieHellmanKeyAgreement {
            fileprivate var baseKey: Curve25519PrivateKeyImpl

            /// Generates a new X25519 private key.
            public init() {
                self.baseKey = Curve25519PrivateKeyImpl()
            }

            /// Returns the associated X25519 public key.
            ///
            /// - Returns: The public key
            public var publicKey: PublicKey {
                return PublicKey(baseKey: self.baseKey.publicKey)
            }

            /// Initializes the key with data.
            ///
            /// - Parameter data: The 32-bytes representation of the private key.
//            public init<D: ContiguousBytes>(rawRepresentation: D) throws {
//                self.baseKey = try Curve25519PrivateKeyImpl(rawRepresentation: rawRepresentation)
//            }

            /// Performs an elliptic curve Diffie-Hellmann key agreement over X25519.
            ///
            /// - Parameter publicKeyShare: The public key share to perform the key agreement with.
            /// - Returns: The shared secret
            /// - Throws: Throws if the operation failed to be performed.
            public func sharedSecretFromKeyAgreement(with publicKeyShare: PublicKey) throws -> SharedSecret {
                return try self.baseKey.sharedSecretFromKeyAgreement(with: publicKeyShare.baseKey)
            }

            /// A data representation of the private key
            public var rawRepresentation: Data {
                return self.baseKey.rawRepresentation
            }

            var key: Data {
                return self.baseKey.key
            }
        }
    }
}
