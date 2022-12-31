import Foundation

extension FixedWidthInteger {
	/// Returns bytes in Big Endian or Network Byte Ordering.
	public var bigEndianBytes: Data {
		withUnsafeBytes(of: bigEndian, { Data(bytes: $0.baseAddress!, count: $0.count) })
	}

	/// Returns bytes in Little Endian.
	public var littleEndianBytes: Data {
		withUnsafeBytes(of: littleEndian, { Data(bytes: $0.baseAddress!, count: $0.count) })
	}
}
