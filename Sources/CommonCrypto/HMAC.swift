//
//  HMAC.swift
//  HAP
//
//  Created by Bouke Haarsma on 08-07-16.
//
//

import Foundation
import CCommonCrypto

public class HMAC {
    public enum Algorithm {
        case SHA1
        case SHA256
        case SHA512

        public var length: Int {
            switch self {
            case .SHA1: return Int(CC_SHA1_DIGEST_LENGTH)
            case .SHA256: return Int(CC_SHA256_DIGEST_LENGTH)
            case .SHA512: return Int(CC_SHA512_DIGEST_LENGTH)
            }
        }

        var algorithm: CCHmacAlgorithm {
            switch self {
            case .SHA1: return CCHmacAlgorithm(kCCHmacAlgSHA1)
            case .SHA256: return CCHmacAlgorithm(kCCHmacAlgSHA256)
            case .SHA512: return CCHmacAlgorithm(kCCHmacAlgSHA512)
            }
        }
    }

    typealias Context = UnsafeMutablePointer<CCHmacContext>

    var algorithm: Algorithm
    var context = Context(allocatingCapacity: 1)

    public init(algorithm: Algorithm, key: Data) {
        self.algorithm = algorithm
        key.withUnsafeBytes { pKey in
            CCHmacInit(context, algorithm.algorithm, pKey, key.count)
        }
    }

    @discardableResult
    public func update(_ data: Data) -> Self {
        data.withUnsafeBytes { pData in
            CCHmacUpdate(context, pData, data.count)
        }
        return self
    }

    public func final() -> Data {
        var mac = Data(count: algorithm.length)!
        mac.withUnsafeMutableBytes { pMac in
            CCHmacFinal(context, pMac)
        }
        return mac
    }
}
