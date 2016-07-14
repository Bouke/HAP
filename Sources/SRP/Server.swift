import Foundation
import Bignum
import CommonCrypto

public class Server {
    internal let b: Bignum
    public let B: Data

    public let salt: Data
    public let username: String

    internal let v: Bignum

    internal let group: Group
    internal let alg: HashAlgorithm

    public private(set) var isAuthenticated = false
    public private(set) var sessionKey: Data? = nil

    public init (group: Group = .N2048, alg: HashAlgorithm = .SHA1, salt: Data, username: String, verificationKey: Data, secret: Data? = nil) {
        self.group = group
        self.alg = alg
        self.salt = salt
        self.username = username

        if let secret = secret {
            b = Bignum(data: secret)
        } else {
            b = Bignum(data: generateRandomBytes(count: 32))
        }
        let k = calculate_k(group: group, alg: alg)
        v = Bignum(data: verificationKey)
        let N = group.N
        let g = group.g
//        B = k*v + g^b % N
        B = mod_add(k * v, mod_exp(g, b, N), N).data
    }

    public func getChallenge() -> (salt: Data, B: Data) {
        return (salt, B)
    }

    public func verifySession(A: Data, M clientM: Data) throws -> Data {
        let u = calculate_u(group: group, alg: alg, A: A, B: B)
        let A_ = Bignum(data: A)
        let N = group.N

//        S = (Av^u) mod N
        let S = mod_exp(A_ * mod_exp(v, u, N), b, N)

        let H = alg.hash
        sessionKey = H(S.data)

        let M = calculate_M(group: group, alg: alg, username: username, salt: salt, A: A, B: B, K: sessionKey!)
        guard clientM == M else { throw Error.authenticationFailed }
        isAuthenticated = true

        return calculate_HAMK(alg: alg, A: A, M: M, K: sessionKey!)
    }
}
