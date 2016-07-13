//
//  Digest.swift
//  HAP
//
//  Created by Bouke Haarsma on 08-07-16.
//
//

import CCommonCrypto
import Foundation

public enum HashAlgorithm {
    case SHA1
    case SHA512

    public var length: Int {
        switch self {
        case .SHA1: return Int(CC_SHA1_DIGEST_LENGTH)
        case .SHA512: return Int(CC_SHA512_DIGEST_LENGTH)
        }
    }

    var f: (UnsafePointer<Void>, CC_LONG, UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8>! {
        switch self {
        case .SHA1: return CC_SHA1
        case .SHA512: return CC_SHA512
        }
    }

    public func hash(_ data: Data) -> Data {
        var digest = Data(count: length)
        _ = data.withUnsafeBytes { pData in
            digest.withUnsafeMutableBytes { pDigest in
                f(pData, CC_LONG(length), pDigest)
            }
        }
        return digest
    }
}
