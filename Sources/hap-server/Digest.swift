//
//  Digest.swift
//  HAP
//
//  Created by Bouke Haarsma on 08-07-16.
//
//

import CommonCrypto
import Foundation


func sha1(data: Data) -> Data {
    var digest = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
    _ = data.withUnsafeBytes { pData in
        digest.withUnsafeMutableBytes { pDigest in
            CC_SHA1(pData, CC_LONG(data.count), pDigest)
        }
    }
    return digest
}


func sha512(data: Data) -> Data {
    var digest = Data(count: Int(CC_SHA512_DIGEST_LENGTH))
    _ = data.withUnsafeBytes { pData in
        digest.withUnsafeMutableBytes { pDigest in
            CC_SHA512(pData, CC_LONG(data.count), pDigest)
        }
    }
    return digest
}
