//
//  Random.swift
//  HAP
//
//  Created by Bouke Haarsma on 09-07-16.
//
//

import CCommonCrypto
import Foundation

public func generateRandomBytes(count: Int) -> Data {
    var data = Data(count: count)
    _ = data.withUnsafeMutableBytes { pData in
        CCRandomGenerateBytes(pData, count)
    }
    return data
}
