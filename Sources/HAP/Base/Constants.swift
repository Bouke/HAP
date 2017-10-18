public enum CharacteristicType: String {
    case on = "25"
    case brightness = "8"
    case saturation = "2F"
    case hue = "13"
    case currentHumidity = "10"
    case currentTemperature = "11"
    case targetTemperature = "35"
    case currentHeatingCoolingState = "F"
    case targetHeatingCoolingState =  "33"
    case temperatureDisplayUnits = "36"
    case identify = "14"
    case manufacturer = "20"
    case model = "21"
    case name = "23"
    case serialNumber = "30"
    case currentPosition = "6D"
    case positionState = "72"
    case targetPosition = "7C"
    case airQuality = "95"
    case batteryLevel = "68"
    case chargingState = "8F"
    case statusLowBattery = "79"
    case configureBridgedAccessoryStatus = "9D"
    case discoverBridgedAccessories = "9E"
    case discoveredBridgedAccessories = "9F"
    case configureBridgedAccessory = "A0"
    case reachable = "63"
    case linkQuality = "9C"
    case accessoryIdentifier = "57"
    case category = "A3"
    case outletInUse = "26"
    case currentDoorState = "E"
    case targetDoorState = "32"
    case obstructionDetected = "24"
    case lockCurrentState = "1D"
    case lockTargetState = "1E"
    case securitySystemCurrentState = "66"
    case securitySystemTargetState = "67"
    case lightLevel = "6B"
}

public enum CharacteristicPermission: String {
    case read = "pr"
    case write = "pw"
    case events = "ev"
    
    static let ReadWrite: [CharacteristicPermission] = [.read, .write, .events]
}

public enum CharacteristicFormat: String {
    case string = "string"
    case bool = "bool"
    case float = "float"
    case uint8 = "uint8"
    case uint16 = "uint16"
    case uint32 = "uint32"
    case int32 = "int32"
    case uint64 = "uint64"
    case data = "data"
    case tlv8 = "tlv8"
}

public enum CharacteristicUnit: String {
    case percentage = "percentage"
    case arcdegrees = "arcdegrees"
    case celcius = "celcius"
    case lux = "lux"
    case seconds = "seconds"
}


public enum HAPStatusCodes : Int {
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
