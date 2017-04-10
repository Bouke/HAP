import Foundation

public protocol CharacteristicValueType: Equatable {
    init?(value: Any)
    var asAny: Any { get }
    static var format: CharacteristicFormat { get }
}


extension Bool: CharacteristicValueType {
    public var asAny: Any {
        return self as Any
    }
    public init?(value: Any) {
        switch value {
        case let value as Int: self = value == 1
        case let value as Bool: self = value
        default: return nil
        }
    }
    static public let format = CharacteristicFormat.bool
}

extension String: CharacteristicValueType {
    public var asAny: Any {
        return self as Any
    }
    public init?(value: Any) {
        guard let string = value as? String else {
            return nil
        }
        self = string
    }
    static public let format = CharacteristicFormat.string
}

extension Int: CharacteristicValueType {
    public var asAny: Any {
        return self as Any
    }
    public init?(value: Any) {
        guard let int = value as? Int else {
            return nil
        }
        self = int
    }
    static public let format = CharacteristicFormat.uint64
}

extension Double: CharacteristicValueType {
    public var asAny: Any {
        return self as Any
    }
    public init?(value: Any) {
        guard let double = value as? Double else {
            return nil
        }
        self = double
    }
    static public let format = CharacteristicFormat.float
}

extension Float: CharacteristicValueType {
    public var asAny: Any {
        return self as Any
    }
    public init?(value: Any) {
        guard let float = value as? Float else {
            return nil
        }
        self = float
    }
    static public let format = CharacteristicFormat.float
}

extension Data: CharacteristicValueType {
    public var asAny: Any {
        return self as Any
    }
    public init?(value: Any) {
        guard let data = value as? Data else {
            return nil
        }
        self = data
    }
    static public let format = CharacteristicFormat.data
}

extension RawRepresentable where RawValue: CharacteristicValueType {
    public init?(value: Any) {
        guard let rawValue = value as? RawValue else {
            return nil
        }
        self.init(rawValue: rawValue)
    }
    public var asAny: Any {
        return rawValue.asAny
    }
    public static var format: CharacteristicFormat {
        return RawValue.format
    }
}
