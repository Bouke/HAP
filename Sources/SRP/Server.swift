//
//  Verifier2.swift
//  HAP
//
//  Created by Bouke Haarsma on 09-07-16.
//
//

import Foundation
import Bignum
import CommonCrypto

public class Server {
    internal let b: Bignum
    internal let s: Bignum
    internal let v: Bignum
    internal let k: Bignum
    internal let B: Bignum
    internal var N: Bignum
    internal var g: Bignum
    internal var A: Bignum? = nil
    internal var M1: Data? = nil
    internal var M2: Data? = nil
    internal let username: String

    public init (group: Group, salt: Data, username: String, verificationKey: Data, secret: Data) {
//        N, g, s, v = <read from password file>
//        b = random()
//        k = SHA1(N | PAD(g))
//        B = k*v + g^b % N
        N = group.N
        g = group.g
        v = Bignum(data: verificationKey)
        b = Bignum(data: secret)
        s = Bignum(data: salt)
        self.username = username
        k = Bignum(data: sha1(N.data + pad(g.data, to: N)))
        B = k * v + mod_exp(g, b, N)
    }

    public func computeB() -> Data {
        return B.data
    }

    public func setA(_ A: Data) {
//        A = <read from client>
//        u = SHA1(PAD(A) | PAD(B))
//        <premaster secret> = (A * v^u) ^ b % N
        let A = Bignum(data: A)
        let u = Bignum(data: sha1(A.data + B.data))
        let S = mod_exp(A * mod_exp(v, u, N), b, N)
        let K = sha1(S.data)

        let N_XOR_g = (sha1(N.data) ^ sha1(g.data))!
//        print(N_XOR_g)
//        print(sha1(username.data(using: .utf8)!))
        print(K)

        M1 = sha1((sha1(N.data) ^ sha1(g.data))! + sha1(username.data(using: .utf8)!) + s.data + A.data + B.data + K)
        M2 = sha1(A.data + M1! + K)
    }

    public func verifySession(clientM1: Data) throws -> Data {
        print(clientM1)
        print(M1!)
        guard clientM1 == M1 else { throw Error.authenticationFailed }
        return M2!
    }
}
