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

    internal let group: Group
    internal let alg: HashAlgorithm
    internal let H: (Data) -> Data

    public init (group: Group = .N2048, alg: HashAlgorithm = .SHA1, salt: Data, username: String, verificationKey: Data, secret: Data) {
        self.group = group
        self.alg = alg
        H = alg.hash

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
        k = Bignum(data: H(N.data + pad(g.data, to: N)))
        B = mod_add(k * v, mod_exp(g, b, N), N)
//        print(salt == s.data)
    }

    public func computeB() -> Data {
        return B.data
    }

    public func setA(_ A: Data) {
//        A = <read from client>
//        u = SHA1(PAD(A) | PAD(B))
//        S = (Av^u) mod N
        let A = Bignum(data: A)
//        print(N.data.count, A.data.count, B.data.count)
//        abort()
        let u = Bignum(data: H(pad(A.data, to: N) + pad(B.data, to: N)))
        let S = mod_exp(A * mod_exp(v, u, N), b, N)
        let K = H(S.data)

        print("Server K", K)

//        print("H(ABS)", H(A.data + B.data + S.data))

        //M = H(H(N) xor H(g), H(I), s, A, B, K)
//        M1 = H((H(N.data) ^ H(g.data))! + H(username.data(using: .utf8)!) + s.data + A.data + B.data + K)
        M1 = calculateM(group: group, alg: alg, username: username, salt: s.data, A: A.data, B: B.data, K: K)

        M2 = H(A.data + M1! + K)
    }

    public func verifySession(clientM1: Data) throws -> Data {
        print("")
        print(clientM1)
        print(M1!)
        guard clientM1 == M1 else { throw Error.authenticationFailed }
        return M2!
    }
}
