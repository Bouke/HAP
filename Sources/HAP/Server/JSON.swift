import Foundation

public protocol JSONSerializable {
    func serialized() -> [String: JSONValueType]
}

public protocol JSONDeserializable {
    init(_ data: [String: JSONValueType]) throws
}

public protocol JSONValueType { }

extension Array: JSONValueType { }
extension Dictionary: JSONValueType { }
extension String: JSONValueType { }
extension Bool: JSONValueType { }
extension Int: JSONValueType { }
extension UInt64: JSONValueType { }
extension Double: JSONValueType { }
extension NSNull: JSONValueType { }

public protocol JSONValueTypeConvertible {
    var jsonValueType: JSONValueType { get }
}
