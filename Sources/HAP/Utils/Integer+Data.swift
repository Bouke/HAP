import Foundation

extension BinaryInteger {
    init(bytes: [UInt8]) {
        precondition(bytes.count == MemoryLayout<Self>.size, "incorrect number of bytes")
        self = bytes.withUnsafeBufferPointer {
            $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) { //(ptr) -> Result in
                return $0.pointee
            }
        }
    }

    init(data: Data) {
        self.init(bytes: Array(data))
    }
}

extension UnsignedInteger {
    var bytes: Data {
        var copy = self
        // TODO: optimize this
        // TODO: is this a good solution regarding LE/BE?
        return withUnsafePointer(to: &copy) {
            let reversed: ReversedRandomAccessCollection<Data> = Data(bytes: $0, count: MemoryLayout<Self>.size).reversed()
            return Data(reversed)
        }
    }
}
