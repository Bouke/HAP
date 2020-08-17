// Copyright (c) 2019 Apple Inc. and the SwiftCrypto project authors
// Licensed under Apache License v2.0

import Foundation

protocol Signer {
    associatedtype Signature
    func signature<D: DataProtocol>(for data: D) throws -> Signature
}
