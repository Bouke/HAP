//swiftlint:disable identifier_name force_try

#if os(Linux)
    import Cryptor

    /// Will return a single 32-bit value, uniformly distributed but less than
    /// upper_bound. In some situations this method may require multiple
    /// iterations to ensure uniformity.
    func arc4random_uniform(_ upper_bound: UInt32) -> UInt32 {
        var x: UInt32 = 0
        repeat {
            x = try! UInt32(bytes: Random.generate(byteCount: 4))
        } while x >= UInt32.max - UInt32.max % upper_bound
        return x % upper_bound
    }
#endif
