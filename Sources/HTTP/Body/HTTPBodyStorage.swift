import Foundation
import NIOFoundationCompat

/// The internal HTTP body storage enum. This is an implementation detail.
enum HTTPBodyStorage {
    /// Cases
    case none
    case buffer(ByteBuffer)
    case data(Data)
    case staticString(StaticString)
    case dispatchData(DispatchData)
    case string(String)

    /// The size of the HTTP body's data.
    /// `nil` of the body is a non-determinate stream.
    var count: Int? {
        switch self {
        case .data(let data): return data.count
        case .dispatchData(let data): return data.count
        case .staticString(let staticString): return staticString.utf8CodeUnitCount
        case .string(let string): return string.utf8.count
        case .buffer(let buffer): return buffer.readableBytes
        case .none: return 0
        }
    }

    /// Returns static data if not streaming.
    var data: Data? {
        switch self {
        case .buffer(let buffer): return buffer.getData(at: 0, length: buffer.readableBytes)
        case .data(let data): return data
        case .dispatchData(let dispatch): return Data(dispatch)
        case .staticString(let string): return Data(bytes: string.utf8Start, count: string.utf8CodeUnitCount)
        case .string(let string): return Data(string.utf8)
        case .none: return nil
        }
    }
}
