import Foundation

public protocol Characteristic: class, JSONSerializable {
    weak var service: Service? { get set }
    var iid: InstanceID { get set }
    var type: CharacteristicType { get }
    var permissions: [CharacteristicPermission] { get }
    func getValue() -> JSONValueType?
    func setValue(_: Any?, fromConnection: Server.Connection?) throws
    var description: String? { get }
    var format: CharacteristicFormat? { get }
    var unit: CharacteristicUnit? { get }
    var maxLength: Int? { get }
    var maxValue: Double? { get }
    var minValue: Double? { get }
    var minStep: Double? { get }
}

extension Characteristic {
    public func serialized() -> [String: JSONValueType] {
        var serialized: [String: JSONValueType] = [
            "iid": iid,
            "type": type.rawValue,
            "perms": permissions.map { $0.rawValue }
        ]

        if permissions.contains(.read) {
            // TODO: fixit
            serialized["value"] = getValue() ?? 0 //NSNull()
        }

        if let description = description { serialized["description"] = description }
        if let format = format { serialized["format"] = format.rawValue }
        if let unit = unit { serialized["unit"] = unit.rawValue }

        if let maxLength = maxLength { serialized["maxLength"] = maxLength }
        if let maxValue = maxValue { serialized["maxValue"] = maxValue }
        if let minValue = minValue { serialized["minValue"] = minValue }
        if let minStep = minStep { serialized["minStep"] = minStep }

        return serialized
    }
}

public class GenericCharacteristic<T: CharacteristicValueType>: Characteristic, JSONSerializable, Hashable, Equatable {
    enum Error: Swift.Error {
        case valueTypeException
    }

    public weak var service: Service?

    public var iid: InstanceID = 0
    public let type: CharacteristicType

    internal var _value: T?
    public var value: T? {
        get {
            return _value
        }
        set {
            guard newValue != _value else {
                return
            }
            _value = newValue
            guard let device = service?.accessory?.device else {
                return
            }
            device.notify(characteristicListeners: self)
        }
    }

    public func getValue() -> JSONValueType? {
        return value?.jsonValueType
    }

    public func setValue(_ newValue: Any?, fromConnection connection: Server.Connection?) throws {
        switch newValue {
        case let some?:
            guard let newValue = T(value: some) else {
                throw Error.valueTypeException
            }
            _value = newValue
        case .none:
            _value = nil
        }
        _ = onValueChange.map { $0(_value) }
    }

    // Subscribe a listener to value changes from (remote) clients.
    public var onValueChange: [(T?) -> Void] = []

    public let permissions: [CharacteristicPermission]

    public var description: String?
    public let format: CharacteristicFormat?
    public let unit: CharacteristicUnit?

    public let maxLength: Int?
    public var maxValue: Double?
    public var minValue: Double?
    public var minStep: Double?

    public init(type: CharacteristicType,
                value: T? = nil,
                permissions: [CharacteristicPermission] = [.read, .write, .events],
                description: String? = nil,
                format: CharacteristicFormat? = nil,
                unit: CharacteristicUnit? = nil,
                maxLength: Int? = nil,
                maxValue: Double? = nil,
                minValue: Double? = nil,
                minStep: Double? = nil) {
        self.type = type
        self._value = value
        self.permissions = permissions

        self.description = description
        self.format = format ?? T.format
        self.unit = unit

        self.maxLength = maxLength
        self.maxValue = maxValue
        self.minValue = minValue
        self.minStep = minStep
    }

    public var hashValue: Int {
        return iid.hashValue
    }

    public static func == (lhs: GenericCharacteristic, rhs: GenericCharacteristic) -> Bool {
        return lhs === rhs
    }
}
