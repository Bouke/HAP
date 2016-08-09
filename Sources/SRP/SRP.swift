import Foundation
import Bignum
import CommonCrypto


public enum Group {
    case N2048
    case N3072

    var N: Bignum {
        switch self {
        case .N2048:
            return Bignum(hex: "AC6BDB41324A9A9BF166DE5E1389582FAF72B6651987EE07FC3192943DB56050A37329CBB4" +
            "A099ED8193E0757767A13DD52312AB4B03310DCD7F48A9DA04FD50E8083969EDB767B0CF60" +
            "95179A163AB3661A05FBD5FAAAE82918A9962F0B93B855F97993EC975EEAA80D740ADBF4FF" +
            "747359D041D5C33EA71D281E446B14773BCA97B43A23FB801676BD207A436C6481F1D2B907" +
            "8717461A5B9D32E688F87748544523B524B0D57D5EA77A2775D2ECFA032CFBDBF52FB37861" +
            "60279004E57AE6AF874E7303CE53299CCC041C7BC308D82A5698F3A8D0C38271AE35F8E9DB" +
            "FBB694B5C803D89F7AE435DE236D525F54759B65E372FCD68EF20FA7111F9E4AFF73")
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
        case .N2048:
            return Bignum(hex: "2")
        case .N3072:
            return Bignum(hex: "5")
        }
    }
}

public func createSaltedVerificationKey(username: String, password: String, salt: Data? = nil, group: Group = .N2048, alg: HashAlgorithm = .SHA1) -> (salt: Data, verificationKey: Data) {
    let salt = salt ?? generateRandomBytes(count: 16)
    let x = calculate_x(alg: alg, salt: salt, username: username, password: password)
    let v = calculate_v(group: group, x: x)
    return (salt, v.data)
}

func pad(_ data: Data, to size: Int) -> Data {
    return Data(count: size - data.count) + data
}

//u = H(PAD(A) | PAD(B))
func calculate_u(group: Group, alg: HashAlgorithm, A: Data, B: Data) -> Bignum {
    let H = alg.hash
    return Bignum(data: H(pad(A, to: group.N.data.count) + pad(B, to: group.N.data.count)))
}

//M1 = H(H(N) XOR H(g) | H(I) | s | A | B | K)
func calculate_M(group: Group, alg: HashAlgorithm, username: String, salt: Data, A: Data, B: Data, K: Data) -> Data {
    let H = alg.hash
    let HN_xor_Hg = (H(group.N.data) ^ H(group.g.data))!
    let HI = H(username.data(using: .utf8)!)
    return H(HN_xor_Hg + HI + salt + A + B + K)
}

//HAMK = H(A | M | K)
func calculate_HAMK(alg: HashAlgorithm, A: Data, M: Data, K: Data) -> Data {
    let H = alg.hash
    return H(A + M + K)
}

//k = H(N | PAD(g))
func calculate_k(group: Group, alg: HashAlgorithm) -> Bignum {
    let H = alg.hash
    return Bignum(data: H(group.N.data + pad(group.g.data, to: group.N.data.count)))
}

//x = H(s | H(I | ":" | P))
func calculate_x(alg: HashAlgorithm, salt: Data, username: String, password: String) -> Bignum {
    let H = alg.hash
    return Bignum(data: H(salt + H("\(username):\(password)".data(using: .utf8)!)))
}

// v = g^x % N
func calculate_v(group: Group, x: Bignum) -> Bignum {
    return mod_exp(group.g, x, group.N)
}
