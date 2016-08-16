import Foundation

protocol JSONSerializable {
    func serialized() -> [String: AnyObject]
}

protocol JSONDeserializable {
    init(_ data: [String: AnyObject]) throws
}
