import NIO

extension ByteBuffer {
    /// Reserves enough space to allow writing up to `capacity` bytes.
    mutating func reserveWritableCapacity(_ capacity: Int) {
        reserveCapacity(writerIndex + capacity)
    }
}
