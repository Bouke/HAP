import Foundation

public protocol CharacteristicValueType: Equatable, JSONValueTypeConvertible {
    init?(value: Any)
    static var format: CharacteristicFormat { get }
}

extension Optional: CharacteristicValueType, JSONValueTypeConvertible where Wrapped: CharacteristicValueType {
    public init?(value: Any) {
        if let wrapped = Wrapped(value: value) {
            self = .some(wrapped)
        } else {
            return nil
        }
    }

    public static var format: CharacteristicFormat {
        return Wrapped.format
    }

    public var jsonValueType: JSONValueType {
        return map { $0.jsonValueType } ?? NSNull()
    }
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
        if let value = value as? Int {
             self = value
        } else if let value = value as? Bool {
            self = value ? 1 : 0
        } else {
            return nil
        }
    }
    public var asInt: Int {
        return self
    }
    static public let format = CharacteristicFormat.int
    public var jsonValueType: JSONValueType {
        return self
    }
}

extension UInt8: CharacteristicValueType {
    public init?(value: Any) {
        if let value = value as? Int,
            let int = UInt8(exactly: value) {
            self = int
        } else if let value = value as? UInt8 {
            self = value
        } else if let value = value as? Bool {
            self = value ? UInt8(1) : UInt8(0)
        } else {
            return nil
        }
    }
    public var asInt: Int {
        return Int(exactly: self) ?? 0
    }
    static public let format = CharacteristicFormat.uint8
    public var jsonValueType: JSONValueType {
        return self
    }
}

extension UInt16: CharacteristicValueType {
    public init?(value: Any) {
        if let value = value as? Int,
            let int = UInt16(exactly: value) {
            self = int
        } else if let value = value as? UInt16 {
            self = value
        } else if let value = value as? Bool {
            self = value ? UInt16(1) : UInt16(0)
        } else {
            return nil
        }
    }
    public var asInt: Int {
        return Int(exactly: self) ?? 0
    }
    static public let format = CharacteristicFormat.uint16
    public var jsonValueType: JSONValueType {
        return self
    }
}

extension UInt32: CharacteristicValueType {
    public init?(value: Any) {
        if let value = value as? Int,
            let int = UInt32(exactly: value) {
            self = int
        } else if let value = value as? UInt32 {
            self = value
        } else if let value = value as? Bool {
            self = value ? UInt32(1) : UInt32(0)
        } else {
            return nil
        }
    }
    public var asInt: Int {
        return Int(exactly: self) ?? 0
    }
    static public let format = CharacteristicFormat.uint32
    public var jsonValueType: JSONValueType {
        return self
    }
}

extension Float: CharacteristicValueType {
    public init?(value: Any) {
        switch value {
        case let value as Float: self = value
        case let value as Double: self = Float(value)
        case let value as Int: self = Float(value)
        default: return nil
        }
    }
    static public let format = CharacteristicFormat.float
    public var jsonValueType: JSONValueType {
        return self
    }
}

extension Double: CharacteristicValueType {
    public init?(value: Any) {
        switch value {
        case let value as Double: self = value
        case let value as Float: self = Double(value)
        case let value as Int: self = Double(value)
        default: return nil
        }
    }
    static public let format = CharacteristicFormat.float
    public var jsonValueType: JSONValueType {
        return self
    }
}

extension Data: CharacteristicValueType, JSONValueTypeConvertible {
    public init?(value: Any) {
        fatalError("How does deserialization of Data work?")
    }
    static public let format = CharacteristicFormat.data
    public var jsonValueType: JSONValueType {
        fatalError("How does serialization of Data work?")
    }
}

extension RawRepresentable where RawValue: CharacteristicValueType & JSONValueType {
    public init?(value: Any) {
        guard let rawValue = RawValue(value: value) else {
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
