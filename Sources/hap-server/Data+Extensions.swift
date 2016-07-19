import Foundation

// Removed in Xcode 8 beta 3
func + (lhs: Data, rhs: Data) -> Data {
    var result = lhs
    result.append(rhs)
    return result
}

// Removed in Xcode 8 beta 3
extension Data {
    init<S: Sequence where S.Iterator.Element == UInt8>(_ sequence: S) {
        self = Data(bytes: Array(sequence))
    }
}
