public extension ServiceType {
    static let accessoryMetrics = ServiceType(0x0270)
    static let accessoryRuntimeInformation = ServiceType(0x0239)
    static let airPurifier = ServiceType(0x00BB)
    static let airQualitySensor = ServiceType(0x008D)
    static let assetUpdate = ServiceType(0x0267)
    static let battery = ServiceType(0x0096)
    static let carbonDioxideSensor = ServiceType(0x0097)
    static let carbonMonoxideSensor = ServiceType(0x007F)
    static let contactSensor = ServiceType(0x0080)
    static let diagnostics = ServiceType(0x0237)
    static let door = ServiceType(0x0081)
    static let doorbell = ServiceType(0x0121)
    static let fan = ServiceType(0x0040)
    static let fanV2 = ServiceType(0x00B7)
    static let faucet = ServiceType(0x00D7)
    static let filterMaintenance = ServiceType(0x00BA)
    static let firmwareUpdate = ServiceType(0x0236)
    static let garageDoorOpener = ServiceType(0x0041)
    static let heaterCooler = ServiceType(0x00BC)
    static let humidifierDehumidifier = ServiceType(0x00BD)
    static let humiditySensor = ServiceType(0x0082)
    static let info = ServiceType(0x003E)
    static let inputSource = ServiceType(0x00D9)
    static let irrigationSystem = ServiceType(0x00CF)
    static let label = ServiceType(0x00CC)
    static let leakSensor = ServiceType(0x0083)
    static let lightSensor = ServiceType(0x0084)
    static let lightbulb = ServiceType(0x0043)
    static let lockManagement = ServiceType(0x0044)
    static let lockMechanism = ServiceType(0x0045)
    static let microphone = ServiceType(0x0112)
    static let motionSensor = ServiceType(0x0085)
    static let occupancySensor = ServiceType(0x0086)
    static let outlet = ServiceType(0x0047)
    static let securitySystem = ServiceType(0x007E)
    static let slats = ServiceType(0x00B9)
    static let smokeSensor = ServiceType(0x0087)
    static let speaker = ServiceType(0x0113)
    static let statefulProgrammableSwitch = ServiceType(0x0088)
    static let statelessProgrammableSwitch = ServiceType(0x0089)
    static let `switch` = ServiceType(0x0049)
    static let tapManagement = ServiceType(0x022E)
    static let television = ServiceType(0x00D8)
    static let temperatureSensor = ServiceType(0x008A)
    static let thermostat = ServiceType(0x004A)
    static let threadTransport = ServiceType(0x0701)
    static let transferTransportManagement = ServiceType(0x0203)
    static let valve = ServiceType(0x00D0)
    static let wiFiTransport = ServiceType(0x022A)
    static let window = ServiceType(0x008B)
    static let windowCovering = ServiceType(0x008C)
}

extension ServiceType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .accessoryMetrics: return "Accessory Metrics"
        case .accessoryRuntimeInformation: return "Accessory Runtime Information"
        case .airPurifier: return "Air Purifier"
        case .airQualitySensor: return "Air Quality Sensor"
        case .assetUpdate: return "Asset Update"
        case .battery: return "Battery"
        case .carbonDioxideSensor: return "Carbon dioxide Sensor"
        case .carbonMonoxideSensor: return "Carbon monoxide Sensor"
        case .contactSensor: return "Contact Sensor"
        case .diagnostics: return "Diagnostics"
        case .door: return "Door"
        case .doorbell: return "Doorbell"
        case .fan: return "Fan"
        case .fanV2: return "Fan"
        case .faucet: return "Faucet"
        case .filterMaintenance: return "Filter Maintenance"
        case .firmwareUpdate: return "Firmware Update"
        case .garageDoorOpener: return "Garage Door Opener"
        case .heaterCooler: return "Heater-Cooler"
        case .humidifierDehumidifier: return "Humidifier-Dehumidifier"
        case .humiditySensor: return "Humidity Sensor"
        case .info: return "Accessory Information Service"
        case .inputSource: return "Input Source"
        case .irrigationSystem: return "Irrigation-System"
        case .label: return "Label"
        case .leakSensor: return "Leak Sensor"
        case .lightSensor: return "Light Sensor"
        case .lightbulb: return "Lightbulb"
        case .lockManagement: return "Lock Management"
        case .lockMechanism: return "Lock Mechanism"
        case .microphone: return "Microphone"
        case .motionSensor: return "Motion Sensor"
        case .occupancySensor: return "Occupancy Sensor"
        case .outlet: return "Outlet"
        case .securitySystem: return "Security System"
        case .slats: return "Slats"
        case .smokeSensor: return "Smoke Sensor"
        case .speaker: return "Speaker"
        case .statefulProgrammableSwitch: return "Stateful Programmable Switch"
        case .statelessProgrammableSwitch: return "Stateless Programmable Switch"
        case .`switch`: return "Switch"
        case .tapManagement: return "Tap Management"
        case .television: return "Television"
        case .temperatureSensor: return "Temperature Sensor"
        case .thermostat: return "Thermostat"
        case .threadTransport: return "Thread Transport"
        case .transferTransportManagement: return "Transfer Transport Management"
        case .valve: return "Valve"
        case .wiFiTransport: return "Wi-Fi Transport"
        case .window: return "Window"
        case .windowCovering: return "Window Covering"
        case let .appleDefined(typeCode):
            let hex = String(typeCode, radix: 16).uppercased()
            return "Apple Defined (\(hex))"
        case let .custom(uuid):
            return "\(uuid)"
        }
    }
}
