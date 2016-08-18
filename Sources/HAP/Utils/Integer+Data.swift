import Foundation

extension Integer {
    init(bytes: [UInt8]) {
        precondition(bytes.count == MemoryLayout<Self>.size, "incorrect number of bytes")
        self = bytes.withUnsafeBufferPointer() {
            $0.baseAddress!.withMemoryRebound(to: Self.self, capacity: 1) { //(ptr) -> Result in
                return $0.pointee
            }
        }
    }

    init(data: Data) {
        self.init(bytes: Array(data))
    }
}

extension UInt16 {
    var bytes: [UInt8] {
        return [
            UInt8(truncatingBitPattern: self >> 8),
            UInt8(truncatingBitPattern: self)
        ]
    }
}
