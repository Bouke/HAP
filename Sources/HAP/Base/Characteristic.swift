import Foundation
import NIO

public struct AnyCharacteristic {
    let wrapped: Characteristic

    public init<T>(_ characteristic: GenericCharacteristic<T>) {
        wrapped = characteristic
    }

    init(_ characteristic: Characteristic) {
        wrapped = characteristic
    }
}

protocol Characteristic: AnyObject, JSONSerializable {
    var service: Service? { get set }
    var iid: InstanceID { get set }
    var type: CharacteristicType { get }
    var permissions: [CharacteristicPermission] { get }
    func getValue() -> JSONValueType?
    func setValue(_: Any?, fromChannel: Channel?) throws
    var description: String? { get }
    var format: CharacteristicFormat? { get }
    var unit: CharacteristicUnit? { get }
    var maxLength: Int? { get }
    var maxValue: Double? { get }
    var minValue: Double? { get }
    var minStep: Double? { get }
    var validValues: [Double] { get }
    var validValuesRange: Range<Double>? { get }
}

extension Characteristic {
    func serialized() -> [String: JSONValueType] {
        var serialized: [String: JSONValueType] = [
            "iid": iid,
            "type": type.rawValue,
            "perms": permissions.map { $0.rawValue }
        ]

        if permissions.contains(.read) {
            // TODO: fixit
            serialized["value"] = getValue() ?? 0 // NSNull()
        }

        if let description = description { serialized["description"] = description }
        if let format = format { serialized["format"] = format.rawValue }
        if let unit = unit { serialized["unit"] = unit.rawValue }

        if let maxLength = maxLength { serialized["maxLength"] = maxLength }
        if let maxValue = maxValue { serialized["maxValue"] = maxValue }
        if let minValue = minValue { serialized["minValue"] = minValue }
        if let minStep = minStep { serialized["minStep"] = minStep }
        if let validValuesRange = validValuesRange {
            serialized["valid-values-range"] = [validValuesRange.lowerBound, validValuesRange.upperBound]
        } else if !validValues.isEmpty {
            serialized["valid-values"] = validValues
        }

        return serialized
    }
}

public class GenericCharacteristic<T: CharacteristicValueType>: Characteristic, JSONSerializable, Hashable, Equatable {
    enum Error: Swift.Error {
        case valueTypeException
    }

    weak var service: Service?

    internal var iid: InstanceID = 0
    public let type: CharacteristicType

    internal var _value: T?
    public var value: T? {
        get {
            _value
        }
        set {
            guard newValue != _value else {
                return
            }
            precondition(
                !permissions.contains(.read) || newValue != nil,
                "Readable characteristics should have non nil value")

            _value = clip(value: newValue)
            if let device = service?.accessory?.device {
                device.fireCharacteristicChangeEvent(self)
            }
        }
    }

    func getValue() -> JSONValueType? {
        value?.jsonValueType
    }

    func setValue(_ newValue: Any?, fromChannel channel: Channel?) throws {
        switch newValue {
        case let some?:
            guard let newValue = T(value: some) else {
                throw Error.valueTypeException
            }
            _value = clip(value: newValue)
        case .none:
            _value = nil
        }
        service?.characteristic(self, didChangeValue: _value)
    }

    public let permissions: [CharacteristicPermission]

    public var description: String?
    public let format: CharacteristicFormat?
    public let unit: CharacteristicUnit?

    public let maxLength: Int?
    public var maxValue: Double?
    public var minValue: Double?
    public var minStep: Double?
    public var validValues: [Double]
    public var validValuesRange: Range<Double>?

    public init(type: CharacteristicType,
                value: T? = nil,
                permissions: [CharacteristicPermission] = [.read, .write, .events],
                description: String? = nil,
                format: CharacteristicFormat? = nil,
                unit: CharacteristicUnit? = nil,
                maxLength: Int? = nil,
                maxValue: Double? = nil,
                minValue: Double? = nil,
                minStep: Double? = nil,
                validValues: [Double] = [],
                validValuesRange: Range<Double>? = nil) {
        precondition(
            !permissions.contains(.read) || value != nil,
            "Readable characteristics should have non nil value")

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
        self.validValues = validValues
        self.validValuesRange = validValuesRange

        self._value = clip(value: value)
    }

    func clip(value: T?) -> T? {
        if let unwrappedValue = value, let doubleValue = Double(value: unwrappedValue) {
            if let unwrappedMinValue = minValue, doubleValue < unwrappedMinValue {
                return T(value: unwrappedMinValue)!
            }
            if let unwrappedMaxValue = maxValue, doubleValue > unwrappedMaxValue {
                return T(value: unwrappedMaxValue)!
            }
        }
        return value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(iid)
    }

    public static func == (lhs: GenericCharacteristic, rhs: GenericCharacteristic) -> Bool {
        lhs === rhs
    }

    internal var device: Device? {
        service?.accessory?.device
    }
}
