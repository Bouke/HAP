// Copyright (c) 2019 Apple Inc. and the SwiftCrypto project authors
// Licensed under Apache License v2.0

import Foundation
import CLibSodium

protocol DataValidator {
    associatedtype Signature
    func isValidSignature<D: DataProtocol>(_ signature: Signature, for signedData: D) -> Bool
}

extension Curve25519.Signing {
    static var signatureLength: Int {
        return Int(crypto_sign_BYTES)
    }
}

extension Curve25519.Signing.PublicKey: DataValidator {
    typealias Signature = Data

    /// Verifies an EdDSA signature over Curve25519.
    ///
    /// - Parameters:
    ///   - signature: The 64-bytes signature to verify.
    ///   - data: The digest that was signed.
    /// - Returns: True if the signature is valid. False otherwise.
    public func isValidSignature<S: DataProtocol, D: DataProtocol>(_ signature: S, for data: D) -> Bool {
        return self.sodiumIsValidSignature(signature, for: data)
    }
}

extension Curve25519.Signing.PrivateKey: Signer {
    /// Generates an EdDSA signature over Curve25519.
    ///
    /// - Parameter data: The data to sign.
    /// - Returns: The 64-bytes signature.
    /// - Throws: If there is a failure producing the signature.
    public func signature<D: DataProtocol>(for data: D) throws -> Data {
        return try sodiumSignature(for: data)
    }
}
