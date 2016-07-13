//
//  Client.swift
//  HAP
//
//  Created by Bouke Haarsma on 13-07-16.
//
//

import Foundation
import Bignum
import CommonCrypto

public class Client {
    internal let a: Bignum
    internal let A: Bignum
    public let M1: Data
    public let M2: Data

    public init (group: Group, alg: HashAlgorithm, username: String, password: String, salt: Data, B: Data) {
        let N = group.N
        let g = group.g
        let s = Bignum(data: salt)
        let B = Bignum(data: B)
        a = Bignum(data: generateRandomBytes(count: 32))
        A = mod_exp(g, a, N)

        let u = Bignum(data: alg.hash(A.data + B.data))
        let k = Bignum(data: alg.hash(N.data + pad(g.data, to: N)))
        let x = Bignum(data: alg.hash(salt + alg.hash("\(username):\(password)".data(using: .utf8)!)))

        let v = mod_exp(g, x, N)
        // S = (B - kg^x) ^ (a + ux)
        let S = mod_exp(B - k * v, a + u * x, N)
        let K = alg.hash(S.data)

        M1 = alg.hash((alg.hash(N.data) ^ alg.hash(g.data))! + alg.hash(username.data(using: .utf8)!) + s.data + B.data + K)
        M2 = alg.hash(A.data + M1 + K)
    }

    public func computeA() -> Data {
        return A.data
    }

    public func verifySession(H_AMK: Data) throws {
        guard H_AMK == M2 else { throw Error.authenticationFailed }
    }
}
