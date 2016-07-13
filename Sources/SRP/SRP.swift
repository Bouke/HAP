//
//  SRP.swift
//  HAP
//
//  Created by Bouke Haarsma on 30-06-16.
//
//

import Foundation
import CSRP
import Bignum
import CommonCrypto

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

public enum Group {
    case N3072

    var N: Bignum {
        switch self {
        case .N3072:
            return Bignum(hex: "FFFFFFFFFFFFFFFFC90FDAA22168C234C4C6628B80DC1CD129024E08" +
                "8A67CC74020BBEA63B139B22514A08798E3404DDEF9519B3CD3A431B" +
                "302B0A6DF25F14374FE1356D6D51C245E485B576625E7EC6F44C42E9" +
                "A637ED6B0BFF5CB6F406B7EDEE386BFB5A899FA5AE9F24117C4B1FE6" +
                "49286651ECE45B3DC2007CB8A163BF0598DA48361C55D39A69163FA8" +
                "FD24CF5F83655D23DCA3AD961C62F356208552BB9ED529077096966D" +
                "670C354E4ABC9804F1746C08CA18217C32905E462E36CE3BE39E772C" +
                "180E86039B2783A2EC07A28FB5C55DF06F4C52C9DE2BCBF695581718" +
                "3995497CEA956AE515D2261898FA051015728E5A8AAAC42DAD33170D" +
                "04507A33A85521ABDF1CBA64ECFB850458DBEF0A8AEA71575D060C7D" +
                "B3970F85A6E1E4C7ABF5AE8CDB0933D71E8C94E04A25619DCEE3D226" +
                "1AD2EE6BF12FFA06D98A0864D87602733EC86A64521F2B18177B200C" +
                "BBE117577A615D6C770988C0BAD946E208E24FA074E5AB3143DB5BFC" +
                "E0FD108E4B82D120A93AD2CAFFFFFFFFFFFFFFFF")
        }
    }

    var g: Bignum {
        switch self {
        case .N3072:
            return Bignum(hex: "5")
        }
    }
}

public func createSaltedVerificationKey(username: String, password: String, salt: Data, group: Group) -> Data {
    // x = SHA1(s | SHA1(I | ":" | P))
    let x = Bignum(data: sha1(salt + sha1("\(username):\(password)".data(using: .utf8)!)))

    // v = g^x % N
    let v = mod_exp(group.g, x, group.N)
    return v.data
}

func pad(_ data: Data, to number: Bignum) -> Data {
    return Data(repeating: 0, count: number.data.count - data.count) + data
}

func pad(_ data: Data, to size: Int) -> Data {
    return Data(repeating: 0, count: size - data.count) + data
}

func ^ (lhs: Data, rhs: Data) -> Data? {
    guard lhs.count == rhs.count else { return nil }
    var result = Data(count: lhs.count)
    for index in lhs.indices {
        result[index] = lhs[index] ^ rhs[index]
    }
    return result
}

//func k(_ group: Group) -> Bignum {
//    let N = group.N.data
//    let g = group.g.data
//    return Bignum(data: sha1(data: N + Data(repeating: 0, count: N.count - g.count) + g))
//}
