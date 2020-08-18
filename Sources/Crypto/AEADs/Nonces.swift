// Copyright (c) 2019-2020 Apple Inc. and the SwiftCrypto project authors
// Licensed under Apache License v2.0
import Foundation

// MARK: - ChaChaPoly + Nonce
extension ChaChaPoly {
    public struct Nonce: ContiguousBytes, Sequence {
        let bytes: Data

        /// Generates a fresh random Nonce. Unless required by a specification to provide a specific Nonce, this is the recommended initializer.
        public init() {
            try! self.init(data: Data(count: ChaChaPoly.nonceByteCount))
        }

        public init<D: DataProtocol>(data: D) throws {
            if data.count != ChaChaPoly.nonceByteCount {
                throw CryptoKitError.incorrectParameterSize
            }

            self.bytes = Data(data)
        }

        public func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
            return try self.bytes.withUnsafeBytes(body)
        }

        public func makeIterator() -> Array<UInt8>.Iterator {
            self.withUnsafeBytes({ (buffPtr) in
                return Array(buffPtr).makeIterator()
            })
        }
    }
}
