import Foundation
import Bignum
import CommonCrypto

public class Client {
    internal let a: Bignum
    public let A: Data

    internal let group: Group
    internal let alg: HashAlgorithm

    internal let username: String
    internal let password: String

    internal var HAMK: Data? = nil

    public private(set) var isAuthenticated = false
    public private(set) var sessionKey: Data? = nil

    public init (group: Group = .N2048, alg: HashAlgorithm = .SHA1, username: String, password: String, secret: Data? = nil) {
        self.group = group
        self.alg = alg
        self.username = username
        self.password = password

        if let secret = secret {
            a = Bignum(data: secret)
        } else {
            a = Bignum(data: generateRandomBytes(count: 32))
        }
//        A = g^a % N
        A = mod_exp(group.g, a, group.N).data
    }

    public func startAuthentication() -> (username: String, A: Data) {
        return (username, A)
    }

    public func processChallenge(salt: Data, B: Data) -> Data {
        let H = alg.hash
        let N = group.N

        let u = calculate_u(group: group, alg: alg, A: A, B: B)
        let k = calculate_k(group: group, alg: alg)
        let x = calculate_x(alg: alg, salt: salt, username: username, password: password)
        let v = calculate_v(group: group, x: x)

        let B_ = Bignum(data: B)

        // shared secret
        // S = (B - kg^x) ^ (a + ux)
        let S = mod_exp(B_ - k * v, a + u * x, N)

        // session key
        let K = H(S.data)

        // client verification
        let M = calculate_M(group: group, alg: alg, username: username, salt: salt, A: A, B: B, K: K)

        // server verification
        HAMK = calculate_HAMK(alg: alg, A: A, M: M, K: K)
        return M
    }

    public func verifySession(HAMK serverHAMK: Data) throws {
        guard let HAMK = HAMK else { throw Error.authenticationFailed }
        guard HAMK == serverHAMK else { throw Error.authenticationFailed }
        isAuthenticated = true
    }
}
