import Foundation

// Removed in Xcode 8 beta 3
func + (lhs: Data, rhs: Data) -> Data {
    var result = lhs
    result.append(rhs)
    return result
}

// Removed in Xcode 8 beta 3
extension Data {
    init<C: Collection>(_ collection: C) where C.Iterator.Element == UInt8 {
        self = Data(bytes: Array(collection))
    }
}

extension Data {
    init?(hex: String) {
        var result = [UInt8]()
        var from = hex.startIndex
        while from < hex.endIndex {
            guard let to = hex.index(from, offsetBy: 2, limitedBy: hex.endIndex) else {
                return nil
            }
            guard let num = UInt8(hex[from..<to], radix: 16) else {
                return nil
            }
            result.append(num)
            from = to
        }
        self = Data(result)
    }
}

extension RandomAccessCollection where Iterator.Element == UInt8 {
    var hex: String {
        self.reduce("") { $0 + String(format: "%02x", $1) }
    }
}
