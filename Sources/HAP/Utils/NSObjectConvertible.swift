import Foundation

public protocol NSObjectConvertible {
    init?(withNSObject object: NSObject)
    var asNSObject: NSObject { get }
    static var format: Characteristic.Format? { get }
}

extension Bool: NSObjectConvertible {
    public var asNSObject: NSObject {
        return self as NSObject
    }
    public init?(withNSObject object: NSObject) {
        guard let bool = object as? Bool else {
            return nil
        }
        self = bool
    }
    static public var format: Characteristic.Format? {
        return .bool
    }
}

extension String: NSObjectConvertible {
    public var asNSObject: NSObject {
        return self as NSObject
    }
    public init?(withNSObject object: NSObject) {
        guard let string = object as? String else {
            return nil
        }
        self = string
    }
    static public var format: Characteristic.Format? {
        return .string
    }
}

extension Int: NSObjectConvertible {
    public var asNSObject: NSObject {
        return self as NSObject
    }
    public init?(withNSObject object: NSObject) {
        guard let int = object as? Int else {
            return nil
        }
        self = int
    }
    static public var format: Characteristic.Format? {
        return .uint64
    }
}

extension Float: NSObjectConvertible {
    public var asNSObject: NSObject {
        return self as NSObject
    }
    public init?(withNSObject object: NSObject) {
        guard let float = object as? Float else {
            return nil
        }
        self = float
    }
    static public var format: Characteristic.Format? {
        return .float
    }
}

extension Data: NSObjectConvertible {
    public var asNSObject: NSObject {
        return self as NSObject
    }
    public init?(withNSObject object: NSObject) {
        guard let data = object as? Data else {
            return nil
        }
        self = data
    }
    static public var format: Characteristic.Format? {
        return .data
    }
}

extension RawRepresentable where RawValue: NSObjectConvertible {
    public init?(withNSObject object: NSObject) {
        guard let rawValue = object as? RawValue else {
            return nil
        }
        self.init(rawValue: rawValue)
    }
    public var asNSObject: NSObject {
        return rawValue.asNSObject
    }
    public static var format: Characteristic.Format? {
        return RawValue.format
    }
}
