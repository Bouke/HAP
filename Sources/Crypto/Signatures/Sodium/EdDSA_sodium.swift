import Foundation
import CLibSodium

extension Curve25519.Signing.PublicKey {
    // We do this to enable inlinability on these methods.
    @usableFromInline
    static let signatureLength = Curve25519.Signing.signatureLength

    @inlinable
    func sodiumIsValidSignature<S: DataProtocol, D: DataProtocol>(_ signature: S, for data: D) -> Bool {
        guard signature.count == Int(crypto_sign_BYTES) else {
            return false
        }

        // Both fields are potentially discontiguous, so we need to check and flatten them.
        switch (signature.regions.count, data.regions.count) {
        case (1, 1):
            // Both data protocols are secretly contiguous.
            return self.sodiumIsValidSignature(contiguousSignature: signature.regions.first!, contiguousData: data.regions.first!)
        case (1, _):
            // The data isn't contiguous: we make it so.
            return self.sodiumIsValidSignature(contiguousSignature: signature.regions.first!, contiguousData: Array(data))
        case (_, 1):
            // The signature isn't contiguous, make it so.
            return self.sodiumIsValidSignature(contiguousSignature: Array(signature), contiguousData: data.regions.first!)
        case (_, _):
            // Neither are contiguous.
            return self.sodiumIsValidSignature(contiguousSignature: Array(signature), contiguousData: Array(data))
        }
    }

    @inlinable
    func sodiumIsValidSignature<S: ContiguousBytes, D: ContiguousBytes>(contiguousSignature signature: S, contiguousData data: D) -> Bool {
        return signature.withUnsafeBytes { signaturePointer in
            data.withUnsafeBytes { dataPointer in
                self.sodiumIsValidSignature(signaturePointer: signaturePointer, dataPointer: dataPointer)
            }
        }
    }

    // We need this factored out because self.keyBytes is not @usableFromInline, and so we can't see it.
    @usableFromInline
    func sodiumIsValidSignature(signaturePointer: UnsafeRawBufferPointer, dataPointer: UnsafeRawBufferPointer) -> Bool {
        precondition(signaturePointer.count == Curve25519.Signing.PublicKey.signatureLength)
        precondition(self.key.count == 32)

        let rc: CInt = self.key.withUnsafeBytes {  keyPointer in
            crypto_sign_verify_detached(signaturePointer.bindMemory(to: UInt8.self).baseAddress!,
                                        dataPointer.bindMemory(to: UInt8.self).baseAddress,
                                        UInt64(dataPointer.count),
                                        keyPointer.bindMemory(to: UInt8.self).baseAddress!)
        }

        return rc == 0
    }
}

extension Curve25519.Signing.PrivateKey {
    func sodiumSignature<D: DataProtocol>(for data: D) throws -> Data {
        if data.regions.count == 1 {
            return try self.sodiumSignature(forContiguousData: data.regions.first!)
        } else {
            return try self.sodiumSignature(forContiguousData: Array(data))
        }
    }

    @inlinable
    func sodiumSignature<C: ContiguousBytes>(forContiguousData data: C) throws -> Data {
        return try data.withUnsafeBytes {
            try self.sodiumSignature(forDataPointer: $0)
        }
    }

    @usableFromInline
    func sodiumSignature(forDataPointer dataPointer: UnsafeRawBufferPointer) throws -> Data {
        var signature = Data(repeating: 0, count: Curve25519.Signing.PublicKey.signatureLength)

        let rc: CInt = signature.withUnsafeMutableBytes { signaturePointer in
            self.key.withUnsafeBytes { keyPointer in
                precondition(signaturePointer.count == Curve25519.Signing.PublicKey.signatureLength)
                precondition(keyPointer.count == crypto_sign_SECRETKEYBYTES)

                return crypto_sign_detached(signaturePointer.bindMemory(to: UInt8.self).baseAddress!,
                                            nil,
                                            dataPointer.bindMemory(to: UInt8.self).baseAddress,
                                            UInt64(dataPointer.count),
                                            keyPointer.bindMemory(to: UInt8.self).baseAddress!)
            }
        }

        guard rc == 0 else {
            throw CryptoKitError.underlyingCoreCryptoError(error: rc)
        }

        return signature
    }
}
