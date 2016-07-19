import Foundation
import CommonCrypto

public func deriveKey(algorithm: HMAC.Algorithm, seed: Data, info: Data, salt: Data, count: Int) -> Data {
    // extract
    let prk = HMAC(algorithm: algorithm, key: salt).update(seed).final()

    // expand
    let iterations = Int(ceil(Double(count) / Double(algorithm.length)))

    var mixin = Data()
    var result = Data()

    for i in 1...iterations {
        let hmac = HMAC(algorithm: algorithm, key: prk)
        hmac.update(mixin)
        hmac.update(info)
        hmac.update(Data(bytes: [UInt8(i)]))
        mixin = hmac.final()
        result.append(mixin)
    }

    return Data(bytes: Array(result[0..<count]))
}
