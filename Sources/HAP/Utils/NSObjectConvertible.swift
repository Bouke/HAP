import Foundation

public protocol AnyConvertible {
    init?(value: Any)
    var asAny: Any { get }
    static var format: Characteristic.Format? { get }
}

extension Bool: AnyConvertible {
    public var asAny: Any {
        return self as Any
    }
    public init?(value: Any) {
        guard let bool = value as? Bool else {
            return nil
        }
        self = bool
    }
    static public var format: Characteristic.Format? {
        return .bool
    }
}

extension String: AnyConvertible {
    public var asAny: Any {
        return self as Any
    }
    public init?(value: Any) {
        guard let string = value as? String else {
            return nil
        }
        self = string
    }
    static public var format: Characteristic.Format? {
        return .string
    }
}

extension Int: AnyConvertible {
    public var asAny: Any {
        return self as Any
    }
    public init?(value: Any) {
        guard let int = value as? Int else {
            return nil
        }
        self = int
    }
    static public var format: Characteristic.Format? {
        return .uint64
    }
}

extension Double: AnyConvertible {
    public var asAny: Any {
        return self as Any
    }
    public init?(value: Any) {
        guard let double = value as? Double else {
            return nil
        }
        self = double
    }
    static public var format: Characteristic.Format? {
        return .float
    }
}

extension Float: AnyConvertible {
    public var asAny: Any {
        return self as Any
    }
    public init?(value: Any) {
        guard let float = value as? Float else {
            return nil
        }
        self = float
    }
    static public var format: Characteristic.Format? {
        return .float
    }
}

extension Data: AnyConvertible {
    public var asAny: Any {
        return self as Any
    }
    public init?(value: Any) {
        guard let data = value as? Data else {
            return nil
        }
        self = data
    }
    static public var format: Characteristic.Format? {
        return .data
    }
}

extension RawRepresentable where RawValue: AnyConvertible {
    public init?(value: Any) {
        guard let rawValue = value as? RawValue else {
            return nil
        }
        self.init(rawValue: rawValue)
    }
    public var asAny: Any {
        return rawValue.asAny
    }
    public static var format: Characteristic.Format? {
        return RawValue.format
    }
}
