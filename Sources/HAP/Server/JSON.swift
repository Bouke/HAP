import Foundation

public protocol JSONSerializable {
    func serialized() -> [String: Any]
}

public protocol JSONDeserializable {
    init(_ data: [String: Any]) throws
}
