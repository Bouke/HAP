// Copyright (c) 2019 Apple Inc. and the SwiftCrypto project authors
// Licensed under Apache License v2.0

import Foundation
import CLibSodium

extension Curve25519 {
    /// Signing operations on Curve25519
    public enum Signing {
        typealias Curve25519PrivateKeyImpl = Curve25519.Signing.SodiumCurve25519PrivateKeyImpl
        typealias Curve25519PublicKeyImpl = Curve25519.Signing.SodiumCurve25519PublicKeyImpl

    	/// A Private Key for signing
        public struct PrivateKey: ECPrivateKey {
            private var baseKey: Curve25519.Signing.Curve25519PrivateKeyImpl

            /// Generates a Curve25519 Signing Key.
            public init() {
                self.baseKey = Curve25519.Signing.Curve25519PrivateKeyImpl()
            }

            /// The associated public key for verifying signatures done with this private key.
            ///
            /// - Returns: The associated public key
            public var publicKey: PublicKey {
                return PublicKey(baseKey: self.baseKey.publicKey)
            }

            public init<D: ContiguousBytes>(rawRepresentation data: D) throws {
                self.baseKey = try Curve25519.Signing.Curve25519PrivateKeyImpl(rawRepresentation: data)
            }

            /// A data representation of the private key
            public var rawRepresentation: Data {
                return baseKey.rawRepresentation
            }

            var key: Data {
                return self.baseKey.key
            }
        }

        public struct PublicKey {
            private var baseKey: Curve25519.Signing.Curve25519PublicKeyImpl

            public init<D: ContiguousBytes>(rawRepresentation: D) throws {
                self.baseKey = try Curve25519.Signing.Curve25519PublicKeyImpl(rawRepresentation: rawRepresentation)
            }

            fileprivate init(baseKey: Curve25519.Signing.Curve25519PublicKeyImpl) {
                self.baseKey = baseKey
            }

            public var rawRepresentation: Data {
                return self.baseKey.rawRepresentation
            }

            var key: Data {
                return self.baseKey.key
            }
        }
    }
}

