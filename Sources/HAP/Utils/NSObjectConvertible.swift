import Foundation

public protocol NSObjectConvertible {
    init(withNSObject object: NSObject) throws
    var asNSObject: NSObject { get }
    static var format: Characteristic.Format? { get }
}

enum Error: Swift.Error {
    case invalidCast
}

extension Bool: NSObjectConvertible {
    public var asNSObject: NSObject {
        return self as NSObject
    }
    public init(withNSObject object: NSObject) throws {
        guard let bool = object as? Bool else {
            throw Error.invalidCast
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
    public init(withNSObject object: NSObject) throws {
        guard let string = object as? String else {
            throw Error.invalidCast
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
    public init(withNSObject object: NSObject) throws {
        guard let int = object as? Int else {
            throw Error.invalidCast
        }
        self = int
    }
    static public var format: Characteristic.Format? {
        return .uint64
    }
}
