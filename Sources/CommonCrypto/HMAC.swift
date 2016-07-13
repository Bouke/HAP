//
//  HMAC.swift
//  HAP
//
//  Created by Bouke Haarsma on 08-07-16.
//
//

import Foundation
import CCommonCrypto

//func hash(key: Data, data: Data) -> Data {
//    var HMAC = Data(count: Int(CC_SHA512_DIGEST_LENGTH))
//    key.withUnsafeBytes { pKey in
//        data.withUnsafeBytes { pData in
//            HMAC.withUnsafeMutableBytes { pHMAC in
//                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA512), pKey, key.count, pData, data.count, pHMAC)
//            }
//        }
//    }
//    return HMAC
//}
