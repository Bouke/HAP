import Foundation

public enum CharacteristicType: Codable, Equatable {

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
            return String(value, radix: 16)
        case let .custom(uuid):
            return uuid.uuidString
        }
    }

    public static func == (lhs: CharacteristicType, rhs: CharacteristicType) -> Bool {
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
        var container = try decoder.unkeyedContainer()
        if let int = try? container.decode(UInt32.self) {
            self = .appleDefined(int)
        } else if let string = try? container.decode(String.self) {
            guard let uuid = UUID(uuidString: string) else {
                throw DecodeError.malformedUUIDString
            }
            self = .custom(uuid)
        } else {
            throw DecodeError.unsupportedValueType
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        switch self {
        case let .appleDefined(int):
            try container.encode(int)
        case .custom:
            try container.encode(rawValue)
        }
    }
}

// swiftlint:disable no_grouping_extension
public extension CharacteristicType {
    static let on = CharacteristicType(0x25)
    static let brightness = CharacteristicType(0x8)
    static let saturation = CharacteristicType(0x2F)
    static let hue = CharacteristicType(0x13)
    static let currentHumidity = CharacteristicType(0x10)
    static let currentTemperature = CharacteristicType(0x11)
    static let targetTemperature = CharacteristicType(0x35)
    static let currentHeatingCoolingState = CharacteristicType(0xF)
    static let targetHeatingCoolingState = CharacteristicType(0x33)
    static let temperatureDisplayUnits = CharacteristicType(0x36)
    static let identify = CharacteristicType(0x4)
    static let manufacturer = CharacteristicType(0x20)
    static let model = CharacteristicType(0x21)
    static let name = CharacteristicType(0x23)
    static let serialNumber = CharacteristicType(0x30)
    static let currentPosition = CharacteristicType(0x6D)
    static let positionState = CharacteristicType(0x72)
    static let targetPosition = CharacteristicType(0x7C)
    static let airQuality = CharacteristicType(0x95)
    static let batteryLevel = CharacteristicType(0x68)
    static let motionDetected = CharacteristicType(0x22)
    static let occupancyDetected = CharacteristicType(0x71)
    static let programmableSwitchEvent = CharacteristicType(0x73)
    static let smokeDetected = CharacteristicType(0x76)
    static let contactSensorState = CharacteristicType(0x6A)
    static let chargingState = CharacteristicType(0x8F)
    static let statusLowBattery = CharacteristicType(0x79)
    static let configureBridgedAccessoryStatus = CharacteristicType(0x9D)
    static let discoverBridgedAccessories = CharacteristicType(0x9E)
    static let discoveredBridgedAccessories = CharacteristicType(0x9F)
    static let configureBridgedAccessory = CharacteristicType(0xA0)
    static let reachable = CharacteristicType(0x63)
    static let linkQuality = CharacteristicType(0x9C)
    static let accessoryIdentifier = CharacteristicType(0x57)
    static let category = CharacteristicType(0xA3)
    static let outletInUse = CharacteristicType(0x26)
    static let currentDoorState = CharacteristicType(0xE)
    static let targetDoorState = CharacteristicType(0x32)
    static let obstructionDetected = CharacteristicType(0x24)
    static let lockCurrentState = CharacteristicType(0x1D)
    static let lockTargetState = CharacteristicType(0x1E)
    static let securitySystemCurrentState = CharacteristicType(0x66)
    static let securitySystemTargetState = CharacteristicType(0x67)
    static let lightLevel = CharacteristicType(0x6B)
    static let firmwareRevision = CharacteristicType(0x52)
}

public enum CharacteristicPermission: String, Codable {
    // This characteristic can only be read by paired controllers.
    case read = "pr" // paired read

    // This characteristic can only be written by paired controllers.
    case write = "pw" // paired write

    // This characteristic supports events.
    case events = "ev"

    // The following properties are not implemented and included for completeness.

    // This characteristic supports additional authorization data
    case additionalAuthorization = "aa"

    // This characteristic supports timed write procedure
    case timedWrite = "tw"

    // This characteristic is hidden from the user
    case hidden = "hd"

    // Short-hand for "all" permissions.
    static let ReadWrite: [CharacteristicPermission] = [.read, .write, .events]
}

public enum CharacteristicFormat: String, Codable {
    case string
    case bool
    case float
    case uint8
    case uint16
    case uint32
    case int32
    case uint64
    case data
    case tlv8
}

public enum CharacteristicUnit: String, Codable {
    case percentage
    case arcdegrees
    case celcius
    case lux
    case seconds
}

public enum HAPStatusCodes: Int, Codable {
    case success = 0
    case insufficientPrivileges = -70401
    case unableToCommunicate = -70402
    case busy = -70403
    case readOnly = -70404
    case writeOnly = -70405
    case notificationNotSupported = -70406
    case outOfResources = -70407
    case operationTimedOut = -70408
    case resourceDoesNotExist = -70409
    case invalidValue = -70410
    case insufficientAuthorization = -70411
}
