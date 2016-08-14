import Foundation

protocol JSONSerializable {
    func serialize() -> [String: AnyObject]
}

protocol JSONDeserializable {
    func deserialize(_ data: [String: AnyObject]) throws -> Self
}
