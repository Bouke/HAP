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
        var container = encoder.unkeyedContainer()
        try container.encode(rawValue)
    }
}

// swiftlint:disable no_grouping_extension
public extension CharacteristicType {
    static let administratorOnlyAccess = CharacteristicType(0x1)
    static let audioFeedback = CharacteristicType(0x5)
    static let brightness = CharacteristicType(0x8)
    static let coolingThresholdTemperature = CharacteristicType(0xD)
    static let currentDoorState = CharacteristicType(0xE)
    static let currentHeatingCoolingState = CharacteristicType(0xF)
    static let currentRelativeHumidity = CharacteristicType(0x10)
    static let currentTemperature = CharacteristicType(0x11)
    static let heatingThresholdTemperature = CharacteristicType(0x12)
    static let hue = CharacteristicType(0x13)
    static let identify = CharacteristicType(0x14)
    static let lockControlPoint = CharacteristicType(0x19)
    static let lockManagementAutoSecurityTimeout = CharacteristicType(0x1A)
    static let lockLastKnownAction = CharacteristicType(0x1C)
    static let lockCurrentState = CharacteristicType(0x1D)
    static let lockTargetState = CharacteristicType(0x1E)
    static let logs = CharacteristicType(0x1F)
    static let manufacturer = CharacteristicType(0x20)
    static let model = CharacteristicType(0x21)
    static let motionDetected = CharacteristicType(0x22)
    static let name = CharacteristicType(0x23)
    static let obstructionDetected = CharacteristicType(0x24)
    static let on = CharacteristicType(0x25)
    static let outletInUse = CharacteristicType(0x26)
    static let rotationDirection = CharacteristicType(0x28)
    static let rotationSpeed = CharacteristicType(0x29)
    static let saturation = CharacteristicType(0x2F)
    static let serialNumber = CharacteristicType(0x30)
    static let targetDoorState = CharacteristicType(0x32)
    static let targetHeatingCoolingState = CharacteristicType(0x33)
    static let targetRelativeHumidity = CharacteristicType(0x34)
    static let targetTemperature = CharacteristicType(0x35)
    static let temperatureDisplayUnits = CharacteristicType(0x36)
    static let version = CharacteristicType(0x37)
    static let firmwareRevision = CharacteristicType(0x52)
    static let hardwareRevision = CharacteristicType(0x53)
    static let accessoryIdentifier = CharacteristicType(0x57)
    static let reachable = CharacteristicType(0x63)
    static let airParticulateDensity = CharacteristicType(0x64)
    static let airParticulateSize = CharacteristicType(0x65)
    static let securitySystemCurrentState = CharacteristicType(0x66)
    static let securitySystemTargetState = CharacteristicType(0x67)
    static let batteryLevel = CharacteristicType(0x68)
    static let carbonMonoxideDetected = CharacteristicType(0x69)
    static let contactSensorState = CharacteristicType(0x6A)
    static let currentAmbientLightLevel = CharacteristicType(0x6B)
    static let currentHorizontalTiltAngle = CharacteristicType(0x6C)
    static let currentPosition = CharacteristicType(0x6D)
    static let currentVerticalTiltAngle = CharacteristicType(0x6E)
    static let holdPosition = CharacteristicType(0x6F)
    static let leakDetected = CharacteristicType(0x70)
    static let occupancyDetected = CharacteristicType(0x71)
    static let positionState = CharacteristicType(0x72)
    static let programmableSwitchEvent = CharacteristicType(0x73)
    static let statusActive = CharacteristicType(0x75)
    static let smokeDetected = CharacteristicType(0x76)
    static let statusFault = CharacteristicType(0x77)
    static let statusJammed = CharacteristicType(0x78)
    static let statusLowBattery = CharacteristicType(0x79)
    static let statusTampered = CharacteristicType(0x7A)
    static let targetHorizontalTiltAngle = CharacteristicType(0x7B)
    static let targetPosition = CharacteristicType(0x7C)
    static let targetVerticalTiltAngle = CharacteristicType(0x7D)
    static let securitySystemAlarmType = CharacteristicType(0x8E)
    static let chargingState = CharacteristicType(0x8F)
    static let carbonMonoxideLevel = CharacteristicType(0x90)
    static let carbonMonoxidePeakLevel = CharacteristicType(0x91)
    static let carbonDixideDetected = CharacteristicType(0x92)
    static let carbonDixideLevel = CharacteristicType(0x93)
    static let carbonDixidePeakLevel = CharacteristicType(0x94)
    static let airQuality = CharacteristicType(0x95)
    static let linkQuality = CharacteristicType(0x9C)
    static let configureBridgedAccessoryStatus = CharacteristicType(0x9D)
    static let discoverBridgedAccessories = CharacteristicType(0x9E)
    static let discoveredBridgedAccessories = CharacteristicType(0x9F)
    static let configureBridgedAccessory = CharacteristicType(0xA0)
    static let category = CharacteristicType(0xA3)
    static let accessoryFlags = CharacteristicType(0xA6)
    static let lockPhysicalControl = CharacteristicType(0xA7)
    static let targetAirPurifierState = CharacteristicType(0xA8)
    static let currentAirPurifierState = CharacteristicType(0xA9)
    static let currentSlatState = CharacteristicType(0xAA)
    static let filterLifeLevel = CharacteristicType(0xAB)
    static let filterChangeIndication = CharacteristicType(0xAC)
    static let resetFilterIndication = CharacteristicType(0xAD)
    static let currentFanState = CharacteristicType(0xAF)
    static let active = CharacteristicType(0xB0)
    static let swingMode = CharacteristicType(0xB6)
    static let targetFanState = CharacteristicType(0xBF)
    static let slatType = CharacteristicType(0xC0)
    static let currentTiltAngle = CharacteristicType(0xC1)
    static let targetTiltAngle = CharacteristicType(0xC2)
    static let ozoneDensity = CharacteristicType(0xC3)
    static let nitrogenDioxideDensity = CharacteristicType(0xC4)
    static let sulphurDioxideDensity = CharacteristicType(0xC5)
    static let PM25Density = CharacteristicType(0xC6)
    static let PM10Density = CharacteristicType(0xC7)
    static let VOCDensity = CharacteristicType(0xC8)
    static let serviceLabelIndex = CharacteristicType(0xCB)
    static let serviceLabelNamespace = CharacteristicType(0xCD)
    static let colorTemperature = CharacteristicType(0xCE)
    static let supportedVideoStreamConfiguration = CharacteristicType(0x114)
    static let supportedAudioStreamConfiguration = CharacteristicType(0x115)
    static let supportedRTPConfiguration = CharacteristicType(0x116)
    static let selectedRTPStreamConfiguration = CharacteristicType(0x117)
    static let setupEndpoints = CharacteristicType(0x118)
    static let volume = CharacteristicType(0x119)
    static let mute = CharacteristicType(0x11A)
    static let nightVision = CharacteristicType(0x11B)
    static let opticalZoom = CharacteristicType(0x11C)
    static let digitalZoom = CharacteristicType(0x11D)
    static let imageRotation = CharacteristicType(0x11E)
    static let imageMirroring = CharacteristicType(0x11F)
    static let streamingStatus = CharacteristicType(0x120)
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
