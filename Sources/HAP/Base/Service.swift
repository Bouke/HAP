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

// swiftlint:disable no_grouping_extension
public extension ServiceType {
    static let info = ServiceType(0x3E)
    static let lightbulb = ServiceType(0x43)
    static let `switch` = ServiceType(0x49)
    static let thermostat = ServiceType(0x4A)
    static let batteryService = ServiceType(0x96)
    static let bridgeConfiguration = ServiceType(0xA1)
    static let bridgingState = ServiceType(0x62)
    static let contactSensor = ServiceType(0x80)
    static let door = ServiceType(0x81)
    static let humiditySensor = ServiceType(0x82)
    static let lightSensor = ServiceType(0x84)
    static let motionSensor = ServiceType(0x85)
    static let occupancySensor = ServiceType(0x86)
    static let smokeSensor = ServiceType(0x87)
    static let statelessProgrammableSwitch = ServiceType(0x89)
    static let temperatureSensor = ServiceType(0x8A)
    static let window = ServiceType(0x8B)
    static let windowCovering = ServiceType(0x8C)
    static let airQualitySensor = ServiceType(0x8D)
    static let outlet = ServiceType(0x47)
    static let fan = ServiceType(0x40)
    static let garageDoorOpener = ServiceType(0x41)
    static let lockMechanism = ServiceType(0x45)
    static let securitySystem = ServiceType(0x7E)
}

open class Service: JSONSerializable {
    public let type: ServiceType

    weak var accessory: Accessory?

    var iid: InstanceID = 0
    let characteristics: [Characteristic]

    public init(type: ServiceType, characteristics: [AnyCharacteristic]) {
        self.type = type
        self.characteristics = characteristics.map { $0.wrapped }
        self.verify()
    }

    init(type: ServiceType, characteristics: [Characteristic]) {
        self.type = type
        self.characteristics = characteristics
        self.verify()
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

    public func serialized() -> [String: JSONValueType] {
        return [
            "iid": iid,
            "type": type.rawValue,
            "characteristics": characteristics.map { $0.serialized() }
        ]
    }
}
