//
//  Bignum.swift
//  HAP
//
//  Created by Bouke Haarsma on 08-07-16.
//
//

import COpenSSL
import Foundation

public class Bignum {
    private let ctx: UnsafeMutablePointer<BIGNUM>

    init() {
        ctx = BN_new()
    }

    public init(ctx: UnsafeMutablePointer<BIGNUM>) {
        self.ctx = ctx
    }

    public init(hex: String) {
        var ctx: UnsafeMutablePointer<BIGNUM>? = nil
        BN_hex2bn(&ctx, hex)
        self.ctx = ctx!
    }

    public convenience init(data: Data) {
        self.init()
        _ = data.withUnsafeBytes { pData in
            BN_bin2bn(pData, Int32(data.count), ctx)
        }
    }

    deinit {
        BN_free(ctx)
    }

    public var data: Data {
        var data = Data(count: Int((BN_num_bits(ctx) + 7) / 8))
        _ = data.withUnsafeMutableBytes { pData in
            BN_bn2bin(ctx, pData)
        }
        return data
    }

    public var dec: String {
        return String(validatingUTF8: BN_bn2dec(ctx))!
    }

    public var hex: String {
        return String(validatingUTF8: BN_bn2hex(ctx))!
    }
}

extension Bignum: CustomStringConvertible {
    public var description: String {
        return dec
    }
}

internal let ctx = BN_CTX_new()

public func mod_exp(_ a: Bignum, _ p: Bignum, _ m: Bignum) -> Bignum {
    let r = BN_new()
    BN_mod_exp(r, a.ctx, p.ctx, m.ctx, ctx)
//    BN_CTX_free(ctx)
    return Bignum(ctx: r!)
}

public func * (lhs: Bignum, rhs: Bignum) -> Bignum {
    let r = BN_new()
    BN_mul(r, lhs.ctx, rhs.ctx, ctx)
    return Bignum(ctx: r!)
}

public func + (lhs: Bignum, rhs: Bignum) -> Bignum {
    let r = BN_new()
    BN_add(r, lhs.ctx, rhs.ctx)
    return Bignum(ctx: r!)
}

public func - (lhs: Bignum, rhs: Bignum) -> Bignum {
    let r = BN_new()
    BN_sub(r, lhs.ctx, rhs.ctx)
    return Bignum(ctx: r!)
}
