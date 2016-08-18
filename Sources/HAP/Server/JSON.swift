import Foundation

public protocol JSONSerializable {
    func serialized() -> [String: AnyObject]
}

public protocol JSONDeserializable {
    init(_ data: [String: AnyObject]) throws
}
