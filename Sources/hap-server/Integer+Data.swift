import Foundation

extension Integer {
    init(bytes: [UInt8]) {
        precondition(bytes.count == sizeof(Self.self), "incorrect number of bytes")
        self = bytes.withUnsafeBufferPointer() {
            return UnsafePointer($0.baseAddress!).pointee
        }
    }

    init(data: Data) {
        self.init(bytes: Array(data))
    }
}
