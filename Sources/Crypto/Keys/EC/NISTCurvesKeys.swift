// Copyright (c) 2019 Apple Inc. and the SwiftCrypto project authors
// Licensed under Apache License v2.0

import Foundation

protocol ECPublicKey {
    init <Bytes: ContiguousBytes>(rawRepresentation: Bytes) throws
    var rawRepresentation: Data { get }
}

protocol ECPrivateKey {
    associatedtype PublicKey
    var publicKey: PublicKey { get }
}
