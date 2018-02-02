public struct CharacteristicType: RawRepresentable, Codable {
    public typealias RawValue = String
    public var rawValue: String

    public init(_ rawValue: RawValue) {
        self.rawValue = rawValue
    }

    public init?(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

// swiftlint:disable no_grouping_extension
public extension CharacteristicType {
    static let on = CharacteristicType("25")
    static let brightness = CharacteristicType("8")
    static let saturation = CharacteristicType("2F")
    static let hue = CharacteristicType("13")
    static let currentHumidity = CharacteristicType("10")
    static let currentTemperature = CharacteristicType("11")
    static let targetTemperature = CharacteristicType("35")
    static let currentHeatingCoolingState = CharacteristicType("F")
    static let targetHeatingCoolingState = CharacteristicType("33")
    static let temperatureDisplayUnits = CharacteristicType("36")
    static let identify = CharacteristicType("14")
    static let manufacturer = CharacteristicType("20")
    static let model = CharacteristicType("21")
    static let name = CharacteristicType("23")
    static let serialNumber = CharacteristicType("30")
    static let currentPosition = CharacteristicType("6D")
    static let positionState = CharacteristicType("72")
    static let targetPosition = CharacteristicType("7C")
    static let airQuality = CharacteristicType("95")
    static let batteryLevel = CharacteristicType("68")
    static let motionDetected = CharacteristicType("22")
    static let occupancyDetected = CharacteristicType("71")
    static let programmableSwitchEvent = CharacteristicType("73")
    static let smokeDetected = CharacteristicType("76")
    static let contactSensorState = CharacteristicType("6A")
    static let chargingState = CharacteristicType("8F")
    static let statusLowBattery = CharacteristicType("79")
    static let configureBridgedAccessoryStatus = CharacteristicType("9D")
    static let discoverBridgedAccessories = CharacteristicType("9E")
    static let discoveredBridgedAccessories = CharacteristicType("9F")
    static let configureBridgedAccessory = CharacteristicType("A0")
    static let reachable = CharacteristicType("63")
    static let linkQuality = CharacteristicType("9C")
    static let accessoryIdentifier = CharacteristicType("57")
    static let category = CharacteristicType("A3")
    static let outletInUse = CharacteristicType("26")
    static let currentDoorState = CharacteristicType("E")
    static let targetDoorState = CharacteristicType("32")
    static let obstructionDetected = CharacteristicType("24")
    static let lockCurrentState = CharacteristicType("1D")
    static let lockTargetState = CharacteristicType("1E")
    static let securitySystemCurrentState = CharacteristicType("66")
    static let securitySystemTargetState = CharacteristicType("67")
    static let lightLevel = CharacteristicType("6B")
    static let firmwareRevision = CharacteristicType("52")
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
