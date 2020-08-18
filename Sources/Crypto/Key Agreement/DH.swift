// Copyright (c) 2019-2020 Apple Inc. and the SwiftCrypto project authors
// Licensed under Apache License v2.0
import Foundation

/// A Diffie-Hellman Key Agreement Key
protocol DiffieHellmanKeyAgreement {
    /// The public key share type to perform the DH Key Agreement
    associatedtype P
    var publicKey: P { get }

    /// Performs a Diffie-Hellman Key Agreement
    ///
    /// - Parameter publicKeyShare: The public key share
    /// - Returns: The resulting key agreement result
    func sharedSecretFromKeyAgreement(with publicKeyShare: P) throws -> SharedSecret
}

/// A Key Agreement Result
/// A SharedSecret has to go through a Key Derivation Function before being able to use by a symmetric key operation.
public struct SharedSecret: ContiguousBytes {
    var ss: Data

    public func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        return try ss.withUnsafeBytes(body)
    }

    /// Derives a symmetric encryption key using HKDF key derivation.
    ///
    /// - Parameters:
    ///   - hashFunction: The Hash Function to use for key derivation.
    ///   - salt: The salt to use for key derivation.
    ///   - sharedInfo: The Shared Info to use for key derivation.
    ///   - outputByteCount: The length in bytes of resulting symmetric key.
    /// - Returns: The derived symmetric key
    // public func hkdfDerivedSymmetricKey<H: HashFunction, Salt: DataProtocol, SI: DataProtocol>(using hashFunction: H.Type, salt: Salt, sharedInfo: SI, outputByteCount: Int) -> SymmetricKey {
    //     return HKDF<H>.deriveKey(inputKeyMaterial: SymmetricKey(data: ss), salt: salt, info: sharedInfo, outputByteCount: outputByteCount)
    // }
}

extension SharedSecret: Hashable {
    public func hash(into hasher: inout Hasher) {
        ss.withUnsafeBytes { hasher.combine(bytes: $0) }
    }
}

//extension HashFunction {
//    // A wrapper function to keep the unsafe code in one place.
//    mutating func update(_ secret: SharedSecret) {
//        secret.withUnsafeBytes {
//            self.update(bufferPointer: $0)
//        }
//    }
//    mutating func update(_ counter: UInt32) {
//        withUnsafeBytes(of: counter) {
//            self.update(bufferPointer: $0)
//        }
//    }
//}
