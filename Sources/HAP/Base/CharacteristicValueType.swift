import Foundation

public protocol CharacteristicValueType: Equatable, JSONValueTypeConvertible {
    init?(value: Any)
    static var format: CharacteristicFormat { get }
}

extension Bool: CharacteristicValueType {
    public init?(value: Any) {
        switch value {
        case let value as Int: self = value == 1
        case let value as Bool: self = value
        default: return nil
        }
    }
    static public let format = CharacteristicFormat.bool
    public var jsonValueType: JSONValueType {
        return self
    }
}

extension String: CharacteristicValueType {
    public init?(value: Any) {
        guard let string = value as? String else {
            return nil
        }
        self = string
    }
    static public let format = CharacteristicFormat.string
    public var jsonValueType: JSONValueType {
        return self
    }
}

extension Int: CharacteristicValueType {
    public init?(value: Any) {
        guard let int = value as? Int else {
            return nil
        }
        self = int
    }
    static public let format = CharacteristicFormat.uint64
    public var jsonValueType: JSONValueType {
        return self
    }
}

extension Double: CharacteristicValueType {
    public init?(value: Any) {
        switch value {
        case let value as Double: self = value
        case let value as Int: self = Double(value)
        default: return nil
        }
    }
    static public let format = CharacteristicFormat.float
    public var jsonValueType: JSONValueType {
        return self
    }
}

extension Float: CharacteristicValueType {
    public init?(value: Any) {
        guard let double = value as? Double else {
            return nil
        }
        self = Float(double)
    }
    static public let format = CharacteristicFormat.float
    public var jsonValueType: JSONValueType {
        return Double(self)
    }
}

extension Data: CharacteristicValueType, JSONValueTypeConvertible {
    public init?(value: Any) {
        fatalError("How does deserialization of Data work?")
        guard let data = value as? Data else {
            return nil
        }
        self = data
    }
    static public let format = CharacteristicFormat.data
    public var jsonValueType: JSONValueType {
        fatalError("How does serialization of Data work?")
    }
}

extension RawRepresentable where RawValue: CharacteristicValueType & JSONValueType {
    public init?(value: Any) {
        guard let rawValue = value as? RawValue else {
            return nil
        }
        self.init(rawValue: rawValue)
    }
    public static var format: CharacteristicFormat {
        return RawValue.format
    }
    public var jsonValueType: JSONValueType {
        return rawValue
    }
}
