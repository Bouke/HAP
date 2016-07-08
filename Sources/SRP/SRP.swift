//
//  SRP.swift
//  HAP
//
//  Created by Bouke Haarsma on 30-06-16.
//
//

import Foundation
import CSRP

/**
    Generate a salted verification key for the given username and password and return the tuple: (salt, verificationKey)
    
    - Parameters:
        - algorithm: (Optional) which algorithm to use
        - ngType: (Optional) which Number Generator (prime) to use
        - username: the user's username
        - password: the user's password
 
    - Returns: the tuple (salt, verificationKey)
 */
//public func createSaltedVerificationKey(algorithm: SRP_HashAlgorithm = SRP_SHA1, ngType: SRP_NGType = SRP_NG_2048, username: String, password: String) throws -> (salt: Data, verificationKey: Data) {
//    var bytes_s: UnsafePointer<UInt8>? = nil
//    var len_s: Int32 = 16 // default to 16 bytes
//    var bytes_v: UnsafePointer<UInt8>? = nil
//    var len_v: Int32 = 0
//    srp_create_salted_verification_key(algorithm, ngType, username, password, Int32(strlen(password)), &bytes_s, &len_s, &bytes_v, &len_v, nil, nil)
//    guard bytes_s != nil && bytes_v != nil else { throw Error.authenticationFailed }
//    return (
//        Data(bytes: bytes_s!, count: Int(len_s)),
//        Data(bytes: bytes_v!, count: Int(len_v))
//    )
//}

