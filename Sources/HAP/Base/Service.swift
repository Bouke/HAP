import Foundation

public enum ServiceType: Codable, Equatable {

    case appleDefined(UInt32)
    case custom(UUID)

    init(_ hex: UInt32) {
        self = .appleDefined(hex)
    }

    public init(_ uuid: UUID) {
        self = .custom(uuid)
    }

    var rawValue: String {
        switch self {
        case let .appleDefined(value):
            return String(value, radix: 16).uppercased()
        case let .custom(uuid):
            return uuid.uuidString
        }
    }

    public static func == (lhs: ServiceType, rhs: ServiceType) -> Bool {
        switch (lhs, rhs) {
        case (let .appleDefined(left), let .appleDefined(right)):
            return left == right
        case (let .custom(left), let .custom(right)):
            return left == right
        default:
            return false
        }
    }

    enum DecodeError: Error {
        case unsupportedValueType
        case malformedUUIDString
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            if let int = UInt32(string) {
                self = .appleDefined(int)
            } else if let uuid = UUID(uuidString: string) {
                self = .custom(uuid)
            } else {
                throw DecodeError.malformedUUIDString
            }
        } else {
            throw DecodeError.unsupportedValueType
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

open class Service: NSObject, JSONSerializable {
    public let type: ServiceType

    weak var accessory: Accessory?

    var iid: InstanceID = 0
    let characteristics: [Characteristic]
    var linkedServices = WeakObjectSet<Service>()
    var primary: Bool?
    var hidden: Bool?

    public init(type: ServiceType, characteristics: [AnyCharacteristic]) {
        self.type = type
        self.characteristics = characteristics.map { $0.wrapped }
        super.init()
        self.verify()
    }

    init(type: ServiceType, characteristics: [Characteristic]) {
        self.type = type
        self.characteristics = characteristics
        super.init()
        self.verify()
    }

    func addLinkedService(_ link: Service) {
        linkedServices.addObject(object: link)
    }

    func removeLinkedService(_ link: Service) {
        _ = linkedServices.remove(link)
    }

    func verify() {
        // 5.3.2 Service Objects
        // Array of Characteristic objects. Must not be empty. The maximum
        // number of characteristics must not exceed 100, and each
        // characteristic in the array must have a unique type.
        precondition((1...100).contains(characteristics.count),
                     "Number of characteristics must be 1...100")
        precondition(
            Dictionary(grouping: characteristics, by: { $0.type.rawValue })
                .filter({ $0.value.count > 1 })
                .isEmpty,
            "Service's characteristics must have a unique type")
    }

    /// Characteristic's value was changed by controller. Used for bubbling up
    /// to the device, which will notify the delegate.
    open func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                                didChangeValue newValue: T?) {
        accessory?.characteristic(characteristic, ofService: self, didChangeValue: newValue)
    }

    public func serialized() -> [String: JSONValueType] {
        var json: [String: JSONValueType] = [
            "iid": iid,
            "type": type.rawValue,
            "characteristics": characteristics.map { $0.serialized() }
        ]

        if let primary = primary {
            json["primary"] = primary
        }
        if let hidden = hidden {
            json["hidden"] = hidden
        }

        if !linkedServices.isEmpty {
            json["linked"] = linkedServices.allObjects.map { $0.iid }
        }
        return json
    }
}

func getOrCreateAppend<T>(type: CharacteristicType, characteristics: inout [Characteristic], generator: () -> GenericCharacteristic<T>) -> GenericCharacteristic<T> {
    if let existing = characteristics.first(where: { $0.type == type }) {
        guard let existingCasted = existing as? GenericCharacteristic<T> else {
            preconditionFailure("\(type) needs to have a value type of \(T.self)")
        }
        return existingCasted
    }
    let new = generator()
    characteristics.append(new)
    return new
}

func get<T>(type: CharacteristicType, characteristics: [Characteristic]) -> GenericCharacteristic<T>? {
    return characteristics.first { $0.type == type } as? GenericCharacteristic<T>
}
