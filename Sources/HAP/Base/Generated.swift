// This file has been generated automatically from macOS HAP definitions.
// Don't make changes to this file, but regenerate using `hap-update` instead.
//
//  macOS: Version 10.14.3 (Build 18D109)
//  date: 12 February 2019
//  HAP Version: 718

import Foundation

public enum AccessoryType: String, Codable {
	case other = "1"
	case bridge = "2"
	case fan = "3"
	case garageDoorOpener = "4"
	case lightbulb = "5"
	case doorLock = "6"
	case outlet = "7"
	case `switch` = "8"
	case thermostat = "9"
	case sensor = "10"
	case securitySystem = "11"
	case door = "12"
	case window = "13"
	case windowCovering = "14"
	case programmableSwitch = "15"
	case rangeExtender = "16"
	case ipCamera = "17"
	case videoDoorbell = "18"
	case airPurifier = "19"
	case airHeater = "20"
	case airConditioner = "21"
	case airHumidifier = "22"
	case airDehumidifier = "23"
	case appleTV = "24"
	case speaker = "26"
	case airport = "27"
	case sprinkler = "28"
	case faucet = "29"
	case showerHead = "30"
	case television = "31"
	case targetController = "32"
}

public extension ServiceType {
	static let airPurifier = ServiceType(0x00BB)
	static let airQualitySensor = ServiceType(0x008D)
	static let battery = ServiceType(0x0096)
	static let carbonDioxideSensor = ServiceType(0x0097)
	static let carbonMonoxideSensor = ServiceType(0x007F)
	static let contactSensor = ServiceType(0x0080)
	static let door = ServiceType(0x0081)
	static let doorbell = ServiceType(0x0121)
	static let fan = ServiceType(0x0040)
	static let fanV2 = ServiceType(0x00B7)
	static let faucet = ServiceType(0x00D7)
	static let filterMaintenance = ServiceType(0x00BA)
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
	static let television = ServiceType(0x00D8)
	static let temperatureSensor = ServiceType(0x008A)
	static let thermostat = ServiceType(0x004A)
	static let valve = ServiceType(0x00D0)
	static let window = ServiceType(0x008B)
	static let windowCovering = ServiceType(0x008C)
}

// swiftlint:disable no_grouping_extension
public extension CharacteristicType {
	static let accessoryFlags = CharacteristicType(0x00A6)
	static let active = CharacteristicType(0x00B0)
	static let activeIdentifier = CharacteristicType(0x00E7)
	static let administratorOnlyAccess = CharacteristicType(0x0001)
	static let applicationMatchingIdentifier = CharacteristicType(0x00A4)
	static let audioFeedback = CharacteristicType(0x0005)
	static let batteryLevel = CharacteristicType(0x0068)
	static let brightness = CharacteristicType(0x0008)
	static let carbonDioxideDetected = CharacteristicType(0x0092)
	static let carbonDioxideLevel = CharacteristicType(0x0093)
	static let carbonDioxidePeakLevel = CharacteristicType(0x0094)
	static let carbonMonoxideDetected = CharacteristicType(0x0069)
	static let carbonMonoxideLevel = CharacteristicType(0x0090)
	static let carbonMonoxidePeakLevel = CharacteristicType(0x0091)
	static let chargingState = CharacteristicType(0x008F)
	static let closedCaptions = CharacteristicType(0x00DD)
	static let colorTemperature = CharacteristicType(0x00CE)
	static let configuredName = CharacteristicType(0x00E3)
	static let contactSensorState = CharacteristicType(0x006A)
	static let coolingThresholdTemperature = CharacteristicType(0x000D)
	static let currentAirPurifierState = CharacteristicType(0x00A9)
	static let currentAirQuality = CharacteristicType(0x0095)
	static let currentDoorState = CharacteristicType(0x000E)
	static let currentFanState = CharacteristicType(0x00AF)
	static let currentHeaterCoolerState = CharacteristicType(0x00B1)
	static let currentHeatingCoolingState = CharacteristicType(0x000F)
	static let currentHorizontalTiltAngle = CharacteristicType(0x006C)
	static let currentHumidifierDehumidifierState = CharacteristicType(0x00B3)
	static let currentLightLevel = CharacteristicType(0x006B)
	static let currentPosition = CharacteristicType(0x006D)
	static let currentRelativeHumidity = CharacteristicType(0x0010)
	static let currentSlatState = CharacteristicType(0x00AA)
	static let currentTemperature = CharacteristicType(0x0011)
	static let currentTiltAngle = CharacteristicType(0x00C1)
	static let currentVerticalTiltAngle = CharacteristicType(0x006E)
	static let currentWaterLevel = CharacteristicType(0x00B5)
	static let filterChangeIndication = CharacteristicType(0x00AC)
	static let filterLifeLevel = CharacteristicType(0x00AB)
	static let filterResetChangeIndication = CharacteristicType(0x00AD)
	static let firmwareRevision = CharacteristicType(0x0052)
	static let hardwareRevision = CharacteristicType(0x0053)
	static let heatingThresholdTemperature = CharacteristicType(0x0012)
	static let holdPosition = CharacteristicType(0x006F)
	static let hue = CharacteristicType(0x0013)
	static let identifier = CharacteristicType(0x00E6)
	static let identify = CharacteristicType(0x0014)
	static let inUse = CharacteristicType(0x00D2)
	static let inputDeviceType = CharacteristicType(0x00DC)
	static let inputSourceType = CharacteristicType(0x00DB)
	static let isConfigured = CharacteristicType(0x00D6)
	static let isHidden = CharacteristicType(0x00EB)
	static let labelIndex = CharacteristicType(0x00CB)
	static let labelNamespace = CharacteristicType(0x00CD)
	static let leakDetected = CharacteristicType(0x0070)
	static let lockControlPoint = CharacteristicType(0x0019)
	static let lockCurrentState = CharacteristicType(0x001D)
	static let lockLastKnownAction = CharacteristicType(0x001C)
	static let lockManagementAutoSecurityTimeout = CharacteristicType(0x001A)
	static let lockPhysicalControls = CharacteristicType(0x00A7)
	static let lockTargetState = CharacteristicType(0x001E)
	static let logs = CharacteristicType(0x001F)
	static let manufacturer = CharacteristicType(0x0020)
	static let mediaState = CharacteristicType(0x00E0)
	static let model = CharacteristicType(0x0021)
	static let motionDetected = CharacteristicType(0x0022)
	static let mute = CharacteristicType(0x011A)
	static let name = CharacteristicType(0x0023)
	static let nitrogenDioxideDensity = CharacteristicType(0x00C4)
	static let obstructionDetected = CharacteristicType(0x0024)
	static let occupancyDetected = CharacteristicType(0x0071)
	static let outletInUse = CharacteristicType(0x0026)
	static let ozoneDensity = CharacteristicType(0x00C3)
	static let pm10Density = CharacteristicType(0x00C7)
	static let pm2_5Density = CharacteristicType(0x00C6)
	static let pictureMode = CharacteristicType(0x00E2)
	static let positionState = CharacteristicType(0x0072)
	static let powerMode = CharacteristicType(0x00DE)
	static let powerModeSelection = CharacteristicType(0x00DF)
	static let powerState = CharacteristicType(0x0025)
	static let programMode = CharacteristicType(0x00D1)
	static let programmableSwitchEvent = CharacteristicType(0x0073)
	static let programmableSwitchOutputState = CharacteristicType(0x0074)
	static let relativeHumidityDehumidifierThreshold = CharacteristicType(0x00C9)
	static let relativeHumidityHumidifierThreshold = CharacteristicType(0x00CA)
	static let remainingDuration = CharacteristicType(0x00D4)
	static let remoteKey = CharacteristicType(0x00E1)
	static let rotationDirection = CharacteristicType(0x0028)
	static let rotationSpeed = CharacteristicType(0x0029)
	static let saturation = CharacteristicType(0x002F)
	static let securitySystemAlarmType = CharacteristicType(0x008E)
	static let securitySystemCurrentState = CharacteristicType(0x0066)
	static let securitySystemTargetState = CharacteristicType(0x0067)
	static let serialNumber = CharacteristicType(0x0030)
	static let setDuration = CharacteristicType(0x00D3)
	static let slatType = CharacteristicType(0x00C0)
	static let sleepDiscoveryMode = CharacteristicType(0x00E8)
	static let smokeDetected = CharacteristicType(0x0076)
	static let softwareRevision = CharacteristicType(0x0054)
	static let statusActive = CharacteristicType(0x0075)
	static let statusFault = CharacteristicType(0x0077)
	static let statusLowBattery = CharacteristicType(0x0079)
	static let statusTampered = CharacteristicType(0x007A)
	static let sulphurDioxideDensity = CharacteristicType(0x00C5)
	static let swingMode = CharacteristicType(0x00B6)
	static let targetAirPurifierState = CharacteristicType(0x00A8)
	static let targetDoorState = CharacteristicType(0x0032)
	static let targetFanState = CharacteristicType(0x00BF)
	static let targetHeaterCoolerState = CharacteristicType(0x00B2)
	static let targetHeatingCoolingState = CharacteristicType(0x0033)
	static let targetHorizontalTiltAngle = CharacteristicType(0x007B)
	static let targetHumidifierDehumidifierState = CharacteristicType(0x00B4)
	static let targetPosition = CharacteristicType(0x007C)
	static let targetRelativeHumidity = CharacteristicType(0x0034)
	static let targetTemperature = CharacteristicType(0x0035)
	static let targetTiltAngle = CharacteristicType(0x00C2)
	static let targetVerticalTiltAngle = CharacteristicType(0x007D)
	static let temperatureDisplayUnits = CharacteristicType(0x0036)
	static let valveType = CharacteristicType(0x00D5)
	static let version = CharacteristicType(0x0037)
	static let volatileOrganicCompoundDensity = CharacteristicType(0x00C8)
	static let volume = CharacteristicType(0x0119)
	static let volumeControlType = CharacteristicType(0x00E9)
	static let volumeSelector = CharacteristicType(0x00EA)
}

public enum CharacteristicFormat: String, Codable {
	case bool
	case data
	case float
	case int
	case string
	case tlv8
	case uint16
	case uint32
	case uint8
}

public enum CharacteristicUnit: String, Codable {
	case arcdegrees
	case celsius
	case fahrenheit
	case lux
	case microgramsPerMCubed
	case percentage
	case ppm
	case seconds
}

public class Enums {
	public enum Active: UInt8, CharacteristicValueType {
		case inactive = 0
		case active = 1
	}

	public enum CarbonDioxideDetected: UInt8, CharacteristicValueType {
		case normal = 0
		case abnormal = 1
	}

	public enum ChargingState: UInt8, CharacteristicValueType {
		case notCharging = 0
		case charging = 1
		case notChargeable = 2
	}

	public enum ClosedCaptions: UInt8, CharacteristicValueType {
		case disabled = 0
		case enabled = 1
	}

	public enum ContactSensorState: UInt8, CharacteristicValueType {
		case detected = 0
		case notdetected = 1
	}

	public enum CurrentAirPurifierState: UInt8, CharacteristicValueType {
		case manual = 0
		case auto = 1
	}

	public enum CurrentAirQuality: UInt8, CharacteristicValueType {
		case unknown = 0
		case excellent = 1
		case good = 2
		case fair = 3
		case inferior = 4
		case poor = 5
	}

	public enum CurrentDoorState: UInt8, CharacteristicValueType {
		case open = 0
		case closed = 1
		case opening = 2
		case closing = 3
		case stopped = 4
	}

	public enum CurrentFanState: UInt8, CharacteristicValueType {
		case manual = 0
		case auto = 1
	}

	public enum CurrentHeaterCoolerState: UInt8, CharacteristicValueType {
		case auto = 0
		case heatAuto = 1
		case coolAuto = 2
	}

	public enum CurrentHeatingCoolingState: UInt8, CharacteristicValueType {
		case off = 0
		case heat = 1
		case cool = 2
	}

	public enum CurrentHumidifierDehumidifierState: UInt8, CharacteristicValueType {
		case auto = 0
		case humidifyAuto = 1
		case dehumidifyAuto = 2
	}

	public enum CurrentSlatState: UInt8, CharacteristicValueType {
		case manual = 0
		case auto = 1
	}

	public enum FilterChangeIndication: UInt8, CharacteristicValueType {
		case noChange = 0
		case change = 1
	}

	public enum InputDeviceType: UInt8, CharacteristicValueType {
		case other = 0
		case tv = 1
		case recording = 2
		case tuner = 3
		case playback = 4
		case audiosystem = 5
	}

	public enum InputSourceType: UInt8, CharacteristicValueType {
		case other = 0
		case homescreen = 1
		case tuner = 2
		case hdmi = 3
		case compositevideo = 4
		case svideo = 5
		case componentvideo = 6
		case dvi = 7
		case airplay = 8
		case usb = 9
		case application = 10
	}

	public enum IsConfigured: UInt8, CharacteristicValueType {
		case notconfigured = 0
		case configured = 1
	}

	public enum LeakDetected: UInt8, CharacteristicValueType {
		case leakNotDetected = 0
		case leakDetected = 1
	}

	public enum LockCurrentState: UInt8, CharacteristicValueType {
		case unsecured = 0
		case secured = 1
		case jammed = 2
		case unknown = 3
	}

	public enum LockTargetState: UInt8, CharacteristicValueType {
		case unsecured = 0
		case secured = 1
	}

	public enum OccupancyDetected: UInt8, CharacteristicValueType {
		case occupancyNotDetected = 0
		case occupancyDetected = 1
	}

	public enum PictureMode: UInt16, CharacteristicValueType {
		case other = 0
		case standard = 1
		case calibrated = 2
		case calibrateddark = 3
		case vivid = 4
		case game = 5
		case computer = 6
		case custom = 7
	}

	public enum PositionState: UInt8, CharacteristicValueType {
		case decreasing = 0
		case increasing = 1
		case stopped = 2
	}

	public enum PowerModeSelection: UInt8, CharacteristicValueType {
		case show = 0
		case hide = 1
	}

	public enum RemoteKey: UInt8, CharacteristicValueType {
		case rewind = 0
		case fastforward = 1
		case nexttrack = 2
		case previoustrack = 3
		case arrowup = 4
		case arrowdown = 5
		case arrowleft = 6
		case arrowright = 7
		case select = 8
		case back = 9
		case exit = 10
		case playpause = 11
	}

	public enum RotationDirection: Int, CharacteristicValueType {
		case clockwise = 0
		case counterclockwise = 1
	}

	public enum SecuritySystemCurrentState: UInt8, CharacteristicValueType {
		case stayArm = 0
		case awayArm = 1
		case nightArm = 2
		case disarm = 3
		case alarmTriggered = 4
	}

	public enum SecuritySystemTargetState: UInt8, CharacteristicValueType {
		case stayArm = 0
		case awayArm = 1
		case nightArm = 2
		case disarm = 3
	}

	public enum SleepDiscoveryMode: UInt8, CharacteristicValueType {
		case notdiscoverable = 0
		case alwaysdiscoverable = 1
	}

	public enum SmokeDetected: UInt8, CharacteristicValueType {
		case smokenotdetected = 0
		case smokedetected = 1
	}

	public enum StatusLowBattery: UInt8, CharacteristicValueType {
		case batteryNormal = 0
		case batteryLow = 1
	}

	public enum TargetAirPurifierState: UInt8, CharacteristicValueType {
		case inactive = 0
		case idle = 1
	}

	public enum TargetDoorState: UInt8, CharacteristicValueType {
		case open = 0
		case closed = 1
	}

	public enum TargetFanState: UInt8, CharacteristicValueType {
		case inactive = 0
		case idle = 1
	}

	public enum TargetHeaterCoolerState: UInt8, CharacteristicValueType {
		case inactive = 0
		case idle = 1
		case heating = 2
	}

	public enum TargetHeatingCoolingState: UInt8, CharacteristicValueType {
		case off = 0
		case heat = 1
		case cool = 2
		case auto = 3
	}

	public enum TargetHumidifierDehumidifierState: UInt8, CharacteristicValueType {
		case inactive = 0
		case idle = 1
		case humidifying = 2
	}

	public enum TemperatureDisplayUnits: UInt8, CharacteristicValueType {
		case celcius = 0
		case fahrenheit = 1
	}

	public enum VolumeControlType: UInt8, CharacteristicValueType {
		case none = 0
		case relative = 1
		case relativewithcurrent = 2
		case absolute = 3
	}

	public enum VolumeSelector: UInt8, CharacteristicValueType {
		case increment = 0
		case decrement = 1
	}

}

extension Service {
	open class AirPurifierBase: Service {
		// Required Characteristics
		public let active = PredefinedCharacteristic.active()
		public let currentAirPurifierState = PredefinedCharacteristic.currentAirPurifierState()
		public let targetAirPurifierState = PredefinedCharacteristic.targetAirPurifierState()

		// Optional Characteristics
		public let lockPhysicalControls: GenericCharacteristic<UInt8>?
		public let name: GenericCharacteristic<String>?
		public let rotationSpeed: GenericCharacteristic<Float>?
		public let swingMode: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [active, currentAirPurifierState, targetAirPurifierState]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			lockPhysicalControls = unwrappedOptionalCharacteristics.first { $0.type == .lockPhysicalControls } as? GenericCharacteristic<UInt8>
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			rotationSpeed = unwrappedOptionalCharacteristics.first { $0.type == .rotationSpeed } as? GenericCharacteristic<Float>
			swingMode = unwrappedOptionalCharacteristics.first { $0.type == .swingMode } as? GenericCharacteristic<UInt8>
			super.init(type: .airPurifier, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class AirQualitySensorBase: Service {
		// Required Characteristics
		public let currentAirQuality = PredefinedCharacteristic.currentAirQuality()

		// Optional Characteristics
		public let nitrogenDioxideDensity: GenericCharacteristic<Float>?
		public let ozoneDensity: GenericCharacteristic<Float>?
		public let pm10Density: GenericCharacteristic<Float>?
		public let pm2_5Density: GenericCharacteristic<Float>?
		public let sulphurDioxideDensity: GenericCharacteristic<Float>?
		public let volatileOrganicCompoundDensity: GenericCharacteristic<Float>?
		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [currentAirQuality]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			nitrogenDioxideDensity = unwrappedOptionalCharacteristics.first { $0.type == .nitrogenDioxideDensity } as? GenericCharacteristic<Float>
			ozoneDensity = unwrappedOptionalCharacteristics.first { $0.type == .ozoneDensity } as? GenericCharacteristic<Float>
			pm10Density = unwrappedOptionalCharacteristics.first { $0.type == .pm10Density } as? GenericCharacteristic<Float>
			pm2_5Density = unwrappedOptionalCharacteristics.first { $0.type == .pm2_5Density } as? GenericCharacteristic<Float>
			sulphurDioxideDensity = unwrappedOptionalCharacteristics.first { $0.type == .sulphurDioxideDensity } as? GenericCharacteristic<Float>
			volatileOrganicCompoundDensity = unwrappedOptionalCharacteristics.first { $0.type == .volatileOrganicCompoundDensity } as? GenericCharacteristic<Float>
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			statusActive = unwrappedOptionalCharacteristics.first { $0.type == .statusActive } as? GenericCharacteristic<Bool>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			statusLowBattery = unwrappedOptionalCharacteristics.first { $0.type == .statusLowBattery } as? GenericCharacteristic<Enums.StatusLowBattery>
			statusTampered = unwrappedOptionalCharacteristics.first { $0.type == .statusTampered } as? GenericCharacteristic<UInt8>
			super.init(type: .airQualitySensor, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class BatteryBase: Service {
		// Required Characteristics
		public let batteryLevel = PredefinedCharacteristic.batteryLevel()
		public let chargingState = PredefinedCharacteristic.chargingState()
		public let statusLowBattery = PredefinedCharacteristic.statusLowBattery()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [batteryLevel, chargingState, statusLowBattery]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			super.init(type: .battery, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class CarbonDioxideSensorBase: Service {
		// Required Characteristics
		public let carbonDioxideDetected = PredefinedCharacteristic.carbonDioxideDetected()

		// Optional Characteristics
		public let carbonDioxideLevel: GenericCharacteristic<Float>?
		public let carbonDioxidePeakLevel: GenericCharacteristic<Float>?
		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [carbonDioxideDetected]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			carbonDioxideLevel = unwrappedOptionalCharacteristics.first { $0.type == .carbonDioxideLevel } as? GenericCharacteristic<Float>
			carbonDioxidePeakLevel = unwrappedOptionalCharacteristics.first { $0.type == .carbonDioxidePeakLevel } as? GenericCharacteristic<Float>
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			statusActive = unwrappedOptionalCharacteristics.first { $0.type == .statusActive } as? GenericCharacteristic<Bool>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			statusLowBattery = unwrappedOptionalCharacteristics.first { $0.type == .statusLowBattery } as? GenericCharacteristic<Enums.StatusLowBattery>
			statusTampered = unwrappedOptionalCharacteristics.first { $0.type == .statusTampered } as? GenericCharacteristic<UInt8>
			super.init(type: .carbonDioxideSensor, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class CarbonMonoxideSensorBase: Service {
		// Required Characteristics
		public let carbonMonoxideDetected = PredefinedCharacteristic.carbonMonoxideDetected()

		// Optional Characteristics
		public let carbonMonoxideLevel: GenericCharacteristic<Float>?
		public let carbonMonoxidePeakLevel: GenericCharacteristic<Float>?
		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [carbonMonoxideDetected]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			carbonMonoxideLevel = unwrappedOptionalCharacteristics.first { $0.type == .carbonMonoxideLevel } as? GenericCharacteristic<Float>
			carbonMonoxidePeakLevel = unwrappedOptionalCharacteristics.first { $0.type == .carbonMonoxidePeakLevel } as? GenericCharacteristic<Float>
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			statusActive = unwrappedOptionalCharacteristics.first { $0.type == .statusActive } as? GenericCharacteristic<Bool>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			statusLowBattery = unwrappedOptionalCharacteristics.first { $0.type == .statusLowBattery } as? GenericCharacteristic<Enums.StatusLowBattery>
			statusTampered = unwrappedOptionalCharacteristics.first { $0.type == .statusTampered } as? GenericCharacteristic<UInt8>
			super.init(type: .carbonMonoxideSensor, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class ContactSensorBase: Service {
		// Required Characteristics
		public let contactSensorState = PredefinedCharacteristic.contactSensorState()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [contactSensorState]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			statusActive = unwrappedOptionalCharacteristics.first { $0.type == .statusActive } as? GenericCharacteristic<Bool>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			statusLowBattery = unwrappedOptionalCharacteristics.first { $0.type == .statusLowBattery } as? GenericCharacteristic<Enums.StatusLowBattery>
			statusTampered = unwrappedOptionalCharacteristics.first { $0.type == .statusTampered } as? GenericCharacteristic<UInt8>
			super.init(type: .contactSensor, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class DoorBase: Service {
		// Required Characteristics
		public let currentPosition = PredefinedCharacteristic.currentPosition()
		public let positionState = PredefinedCharacteristic.positionState()
		public let targetPosition = PredefinedCharacteristic.targetPosition()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let obstructionDetected: GenericCharacteristic<Bool>?
		public let holdPosition: GenericCharacteristic<Bool>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [currentPosition, positionState, targetPosition]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			obstructionDetected = unwrappedOptionalCharacteristics.first { $0.type == .obstructionDetected } as? GenericCharacteristic<Bool>
			holdPosition = unwrappedOptionalCharacteristics.first { $0.type == .holdPosition } as? GenericCharacteristic<Bool>
			super.init(type: .door, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class DoorbellBase: Service {
		// Required Characteristics
		public let programmableSwitchEvent = PredefinedCharacteristic.programmableSwitchEvent()

		// Optional Characteristics
		public let brightness: GenericCharacteristic<Int>?
		public let volume: GenericCharacteristic<Int>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [programmableSwitchEvent]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			brightness = unwrappedOptionalCharacteristics.first { $0.type == .brightness } as? GenericCharacteristic<Int>
			volume = unwrappedOptionalCharacteristics.first { $0.type == .volume } as? GenericCharacteristic<Int>
			super.init(type: .doorbell, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class FanBase: Service {
		// Required Characteristics
		public let powerState = PredefinedCharacteristic.powerState()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let rotationDirection: GenericCharacteristic<Enums.RotationDirection>?
		public let rotationSpeed: GenericCharacteristic<Float>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [powerState]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			rotationDirection = unwrappedOptionalCharacteristics.first { $0.type == .rotationDirection } as? GenericCharacteristic<Enums.RotationDirection>
			rotationSpeed = unwrappedOptionalCharacteristics.first { $0.type == .rotationSpeed } as? GenericCharacteristic<Float>
			super.init(type: .fan, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class FanV2Base: Service {
		// Required Characteristics
		public let active = PredefinedCharacteristic.active()

		// Optional Characteristics
		public let currentFanState: GenericCharacteristic<Enums.CurrentFanState>?
		public let targetFanState: GenericCharacteristic<Enums.TargetFanState>?
		public let lockPhysicalControls: GenericCharacteristic<UInt8>?
		public let name: GenericCharacteristic<String>?
		public let rotationDirection: GenericCharacteristic<Enums.RotationDirection>?
		public let rotationSpeed: GenericCharacteristic<Float>?
		public let swingMode: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [active]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			currentFanState = unwrappedOptionalCharacteristics.first { $0.type == .currentFanState } as? GenericCharacteristic<Enums.CurrentFanState>
			targetFanState = unwrappedOptionalCharacteristics.first { $0.type == .targetFanState } as? GenericCharacteristic<Enums.TargetFanState>
			lockPhysicalControls = unwrappedOptionalCharacteristics.first { $0.type == .lockPhysicalControls } as? GenericCharacteristic<UInt8>
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			rotationDirection = unwrappedOptionalCharacteristics.first { $0.type == .rotationDirection } as? GenericCharacteristic<Enums.RotationDirection>
			rotationSpeed = unwrappedOptionalCharacteristics.first { $0.type == .rotationSpeed } as? GenericCharacteristic<Float>
			swingMode = unwrappedOptionalCharacteristics.first { $0.type == .swingMode } as? GenericCharacteristic<UInt8>
			super.init(type: .fanV2, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class FaucetBase: Service {
		// Required Characteristics
		public let active = PredefinedCharacteristic.active()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let statusFault: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [active]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			super.init(type: .faucet, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class FilterMaintenanceBase: Service {
		// Required Characteristics
		public let filterChangeIndication = PredefinedCharacteristic.filterChangeIndication()

		// Optional Characteristics
		public let filterLifeLevel: GenericCharacteristic<Float>?
		public let filterResetChangeIndication: GenericCharacteristic<UInt8>?
		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [filterChangeIndication]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			filterLifeLevel = unwrappedOptionalCharacteristics.first { $0.type == .filterLifeLevel } as? GenericCharacteristic<Float>
			filterResetChangeIndication = unwrappedOptionalCharacteristics.first { $0.type == .filterResetChangeIndication } as? GenericCharacteristic<UInt8>
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			super.init(type: .filterMaintenance, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class GarageDoorOpenerBase: Service {
		// Required Characteristics
		public let currentDoorState = PredefinedCharacteristic.currentDoorState()
		public let targetDoorState = PredefinedCharacteristic.targetDoorState()
		public let obstructionDetected = PredefinedCharacteristic.obstructionDetected()

		// Optional Characteristics
		public let lockCurrentState: GenericCharacteristic<Enums.LockCurrentState>?
		public let lockTargetState: GenericCharacteristic<Enums.LockTargetState>?
		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [currentDoorState, targetDoorState, obstructionDetected]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			lockCurrentState = unwrappedOptionalCharacteristics.first { $0.type == .lockCurrentState } as? GenericCharacteristic<Enums.LockCurrentState>
			lockTargetState = unwrappedOptionalCharacteristics.first { $0.type == .lockTargetState } as? GenericCharacteristic<Enums.LockTargetState>
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			super.init(type: .garageDoorOpener, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class HeaterCoolerBase: Service {
		// Required Characteristics
		public let active = PredefinedCharacteristic.active()
		public let currentHeaterCoolerState = PredefinedCharacteristic.currentHeaterCoolerState()
		public let targetHeaterCoolerState = PredefinedCharacteristic.targetHeaterCoolerState()
		public let currentTemperature = PredefinedCharacteristic.currentTemperature()

		// Optional Characteristics
		public let lockPhysicalControls: GenericCharacteristic<UInt8>?
		public let name: GenericCharacteristic<String>?
		public let rotationSpeed: GenericCharacteristic<Float>?
		public let swingMode: GenericCharacteristic<UInt8>?
		public let coolingThresholdTemperature: GenericCharacteristic<Float>?
		public let heatingThresholdTemperature: GenericCharacteristic<Float>?
		public let temperatureDisplayUnits: GenericCharacteristic<Enums.TemperatureDisplayUnits>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [active, currentHeaterCoolerState, targetHeaterCoolerState, currentTemperature]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			lockPhysicalControls = unwrappedOptionalCharacteristics.first { $0.type == .lockPhysicalControls } as? GenericCharacteristic<UInt8>
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			rotationSpeed = unwrappedOptionalCharacteristics.first { $0.type == .rotationSpeed } as? GenericCharacteristic<Float>
			swingMode = unwrappedOptionalCharacteristics.first { $0.type == .swingMode } as? GenericCharacteristic<UInt8>
			coolingThresholdTemperature = unwrappedOptionalCharacteristics.first { $0.type == .coolingThresholdTemperature } as? GenericCharacteristic<Float>
			heatingThresholdTemperature = unwrappedOptionalCharacteristics.first { $0.type == .heatingThresholdTemperature } as? GenericCharacteristic<Float>
			temperatureDisplayUnits = unwrappedOptionalCharacteristics.first { $0.type == .temperatureDisplayUnits } as? GenericCharacteristic<Enums.TemperatureDisplayUnits>
			super.init(type: .heaterCooler, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class HumidifierDehumidifierBase: Service {
		// Required Characteristics
		public let active = PredefinedCharacteristic.active()
		public let currentHumidifierDehumidifierState = PredefinedCharacteristic.currentHumidifierDehumidifierState()
		public let targetHumidifierDehumidifierState = PredefinedCharacteristic.targetHumidifierDehumidifierState()
		public let currentRelativeHumidity = PredefinedCharacteristic.currentRelativeHumidity()

		// Optional Characteristics
		public let lockPhysicalControls: GenericCharacteristic<UInt8>?
		public let name: GenericCharacteristic<String>?
		public let relativeHumidityDehumidifierThreshold: GenericCharacteristic<Float>?
		public let relativeHumidityHumidifierThreshold: GenericCharacteristic<Float>?
		public let rotationSpeed: GenericCharacteristic<Float>?
		public let swingMode: GenericCharacteristic<UInt8>?
		public let currentWaterLevel: GenericCharacteristic<Float>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [active, currentHumidifierDehumidifierState, targetHumidifierDehumidifierState, currentRelativeHumidity]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			lockPhysicalControls = unwrappedOptionalCharacteristics.first { $0.type == .lockPhysicalControls } as? GenericCharacteristic<UInt8>
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			relativeHumidityDehumidifierThreshold = unwrappedOptionalCharacteristics.first { $0.type == .relativeHumidityDehumidifierThreshold } as? GenericCharacteristic<Float>
			relativeHumidityHumidifierThreshold = unwrappedOptionalCharacteristics.first { $0.type == .relativeHumidityHumidifierThreshold } as? GenericCharacteristic<Float>
			rotationSpeed = unwrappedOptionalCharacteristics.first { $0.type == .rotationSpeed } as? GenericCharacteristic<Float>
			swingMode = unwrappedOptionalCharacteristics.first { $0.type == .swingMode } as? GenericCharacteristic<UInt8>
			currentWaterLevel = unwrappedOptionalCharacteristics.first { $0.type == .currentWaterLevel } as? GenericCharacteristic<Float>
			super.init(type: .humidifierDehumidifier, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class HumiditySensorBase: Service {
		// Required Characteristics
		public let currentRelativeHumidity = PredefinedCharacteristic.currentRelativeHumidity()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [currentRelativeHumidity]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			statusActive = unwrappedOptionalCharacteristics.first { $0.type == .statusActive } as? GenericCharacteristic<Bool>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			statusLowBattery = unwrappedOptionalCharacteristics.first { $0.type == .statusLowBattery } as? GenericCharacteristic<Enums.StatusLowBattery>
			statusTampered = unwrappedOptionalCharacteristics.first { $0.type == .statusTampered } as? GenericCharacteristic<UInt8>
			super.init(type: .humiditySensor, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class InfoBase: Service {
		// Required Characteristics
		public let identify = PredefinedCharacteristic.identify()
		public let manufacturer = PredefinedCharacteristic.manufacturer()
		public let model = PredefinedCharacteristic.model()
		public let name = PredefinedCharacteristic.name()
		public let serialNumber = PredefinedCharacteristic.serialNumber()

		// Optional Characteristics
		public let accessoryFlags: GenericCharacteristic<UInt32>?
		public let applicationMatchingIdentifier: GenericCharacteristic<Data>?
		public let firmwareRevision: GenericCharacteristic<String>?
		public let hardwareRevision: GenericCharacteristic<String>?
		public let softwareRevision: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [identify, manufacturer, model, name, serialNumber]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			accessoryFlags = unwrappedOptionalCharacteristics.first { $0.type == .accessoryFlags } as? GenericCharacteristic<UInt32>
			applicationMatchingIdentifier = unwrappedOptionalCharacteristics.first { $0.type == .applicationMatchingIdentifier } as? GenericCharacteristic<Data>
			firmwareRevision = unwrappedOptionalCharacteristics.first { $0.type == .firmwareRevision } as? GenericCharacteristic<String>
			hardwareRevision = unwrappedOptionalCharacteristics.first { $0.type == .hardwareRevision } as? GenericCharacteristic<String>
			softwareRevision = unwrappedOptionalCharacteristics.first { $0.type == .softwareRevision } as? GenericCharacteristic<String>
			super.init(type: .info, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class InputSourceBase: Service {
		// Required Characteristics
		public let configuredName = PredefinedCharacteristic.configuredName()
		public let inputSourceType = PredefinedCharacteristic.inputSourceType()
		public let isConfigured = PredefinedCharacteristic.isConfigured()
		public let name = PredefinedCharacteristic.name()

		// Optional Characteristics
		public let identifier: GenericCharacteristic<UInt32>?
		public let inputDeviceType: GenericCharacteristic<Enums.InputDeviceType>?
		public let isHidden: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [configuredName, inputSourceType, isConfigured, name]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			identifier = unwrappedOptionalCharacteristics.first { $0.type == .identifier } as? GenericCharacteristic<UInt32>
			inputDeviceType = unwrappedOptionalCharacteristics.first { $0.type == .inputDeviceType } as? GenericCharacteristic<Enums.InputDeviceType>
			isHidden = unwrappedOptionalCharacteristics.first { $0.type == .isHidden } as? GenericCharacteristic<UInt8>
			super.init(type: .inputSource, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class IrrigationSystemBase: Service {
		// Required Characteristics
		public let active = PredefinedCharacteristic.active()
		public let programMode = PredefinedCharacteristic.programMode()
		public let inUse = PredefinedCharacteristic.inUse()

		// Optional Characteristics
		public let remainingDuration: GenericCharacteristic<UInt32>?
		public let name: GenericCharacteristic<String>?
		public let statusFault: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [active, programMode, inUse]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			remainingDuration = unwrappedOptionalCharacteristics.first { $0.type == .remainingDuration } as? GenericCharacteristic<UInt32>
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			super.init(type: .irrigationSystem, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class LabelBase: Service {
		// Required Characteristics
		public let labelNamespace = PredefinedCharacteristic.labelNamespace()

		// Optional Characteristics

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [labelNamespace]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			super.init(type: .label, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class LeakSensorBase: Service {
		// Required Characteristics
		public let leakDetected = PredefinedCharacteristic.leakDetected()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [leakDetected]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			statusActive = unwrappedOptionalCharacteristics.first { $0.type == .statusActive } as? GenericCharacteristic<Bool>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			statusLowBattery = unwrappedOptionalCharacteristics.first { $0.type == .statusLowBattery } as? GenericCharacteristic<Enums.StatusLowBattery>
			statusTampered = unwrappedOptionalCharacteristics.first { $0.type == .statusTampered } as? GenericCharacteristic<UInt8>
			super.init(type: .leakSensor, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class LightSensorBase: Service {
		// Required Characteristics
		public let currentLightLevel = PredefinedCharacteristic.currentLightLevel()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [currentLightLevel]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			statusActive = unwrappedOptionalCharacteristics.first { $0.type == .statusActive } as? GenericCharacteristic<Bool>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			statusLowBattery = unwrappedOptionalCharacteristics.first { $0.type == .statusLowBattery } as? GenericCharacteristic<Enums.StatusLowBattery>
			statusTampered = unwrappedOptionalCharacteristics.first { $0.type == .statusTampered } as? GenericCharacteristic<UInt8>
			super.init(type: .lightSensor, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class LightbulbBase: Service {
		// Required Characteristics
		public let powerState = PredefinedCharacteristic.powerState()

		// Optional Characteristics
		public let brightness: GenericCharacteristic<Int>?
		public let colorTemperature: GenericCharacteristic<Int>?
		public let hue: GenericCharacteristic<Float>?
		public let name: GenericCharacteristic<String>?
		public let saturation: GenericCharacteristic<Float>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [powerState]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			brightness = unwrappedOptionalCharacteristics.first { $0.type == .brightness } as? GenericCharacteristic<Int>
			colorTemperature = unwrappedOptionalCharacteristics.first { $0.type == .colorTemperature } as? GenericCharacteristic<Int>
			hue = unwrappedOptionalCharacteristics.first { $0.type == .hue } as? GenericCharacteristic<Float>
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			saturation = unwrappedOptionalCharacteristics.first { $0.type == .saturation } as? GenericCharacteristic<Float>
			super.init(type: .lightbulb, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class LockManagementBase: Service {
		// Required Characteristics
		public let lockControlPoint = PredefinedCharacteristic.lockControlPoint()
		public let version = PredefinedCharacteristic.version()

		// Optional Characteristics
		public let administratorOnlyAccess: GenericCharacteristic<Bool>?
		public let audioFeedback: GenericCharacteristic<Bool>?
		public let currentDoorState: GenericCharacteristic<Enums.CurrentDoorState>?
		public let lockManagementAutoSecurityTimeout: GenericCharacteristic<UInt32>?
		public let lockLastKnownAction: GenericCharacteristic<UInt8>?
		public let logs: GenericCharacteristic<Data>?
		public let motionDetected: GenericCharacteristic<Bool>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [lockControlPoint, version]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			administratorOnlyAccess = unwrappedOptionalCharacteristics.first { $0.type == .administratorOnlyAccess } as? GenericCharacteristic<Bool>
			audioFeedback = unwrappedOptionalCharacteristics.first { $0.type == .audioFeedback } as? GenericCharacteristic<Bool>
			currentDoorState = unwrappedOptionalCharacteristics.first { $0.type == .currentDoorState } as? GenericCharacteristic<Enums.CurrentDoorState>
			lockManagementAutoSecurityTimeout = unwrappedOptionalCharacteristics.first { $0.type == .lockManagementAutoSecurityTimeout } as? GenericCharacteristic<UInt32>
			lockLastKnownAction = unwrappedOptionalCharacteristics.first { $0.type == .lockLastKnownAction } as? GenericCharacteristic<UInt8>
			logs = unwrappedOptionalCharacteristics.first { $0.type == .logs } as? GenericCharacteristic<Data>
			motionDetected = unwrappedOptionalCharacteristics.first { $0.type == .motionDetected } as? GenericCharacteristic<Bool>
			super.init(type: .lockManagement, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class LockMechanismBase: Service {
		// Required Characteristics
		public let lockCurrentState = PredefinedCharacteristic.lockCurrentState()
		public let lockTargetState = PredefinedCharacteristic.lockTargetState()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [lockCurrentState, lockTargetState]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			super.init(type: .lockMechanism, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class MicrophoneBase: Service {
		// Required Characteristics
		public let mute = PredefinedCharacteristic.mute()

		// Optional Characteristics
		public let volume: GenericCharacteristic<Int>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [mute]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			volume = unwrappedOptionalCharacteristics.first { $0.type == .volume } as? GenericCharacteristic<Int>
			super.init(type: .microphone, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class MotionSensorBase: Service {
		// Required Characteristics
		public let motionDetected = PredefinedCharacteristic.motionDetected()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [motionDetected]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			statusActive = unwrappedOptionalCharacteristics.first { $0.type == .statusActive } as? GenericCharacteristic<Bool>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			statusLowBattery = unwrappedOptionalCharacteristics.first { $0.type == .statusLowBattery } as? GenericCharacteristic<Enums.StatusLowBattery>
			statusTampered = unwrappedOptionalCharacteristics.first { $0.type == .statusTampered } as? GenericCharacteristic<UInt8>
			super.init(type: .motionSensor, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class OccupancySensorBase: Service {
		// Required Characteristics
		public let occupancyDetected = PredefinedCharacteristic.occupancyDetected()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [occupancyDetected]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			statusActive = unwrappedOptionalCharacteristics.first { $0.type == .statusActive } as? GenericCharacteristic<Bool>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			statusLowBattery = unwrappedOptionalCharacteristics.first { $0.type == .statusLowBattery } as? GenericCharacteristic<Enums.StatusLowBattery>
			statusTampered = unwrappedOptionalCharacteristics.first { $0.type == .statusTampered } as? GenericCharacteristic<UInt8>
			super.init(type: .occupancySensor, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class OutletBase: Service {
		// Required Characteristics
		public let powerState = PredefinedCharacteristic.powerState()
		public let outletInUse = PredefinedCharacteristic.outletInUse()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [powerState, outletInUse]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			super.init(type: .outlet, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class SecuritySystemBase: Service {
		// Required Characteristics
		public let securitySystemCurrentState = PredefinedCharacteristic.securitySystemCurrentState()
		public let securitySystemTargetState = PredefinedCharacteristic.securitySystemTargetState()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let securitySystemAlarmType: GenericCharacteristic<UInt8>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [securitySystemCurrentState, securitySystemTargetState]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			securitySystemAlarmType = unwrappedOptionalCharacteristics.first { $0.type == .securitySystemAlarmType } as? GenericCharacteristic<UInt8>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			statusTampered = unwrappedOptionalCharacteristics.first { $0.type == .statusTampered } as? GenericCharacteristic<UInt8>
			super.init(type: .securitySystem, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class SlatsBase: Service {
		// Required Characteristics
		public let currentSlatState = PredefinedCharacteristic.currentSlatState()
		public let slatType = PredefinedCharacteristic.slatType()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let swingMode: GenericCharacteristic<UInt8>?
		public let currentTiltAngle: GenericCharacteristic<Int>?
		public let targetTiltAngle: GenericCharacteristic<Int>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [currentSlatState, slatType]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			swingMode = unwrappedOptionalCharacteristics.first { $0.type == .swingMode } as? GenericCharacteristic<UInt8>
			currentTiltAngle = unwrappedOptionalCharacteristics.first { $0.type == .currentTiltAngle } as? GenericCharacteristic<Int>
			targetTiltAngle = unwrappedOptionalCharacteristics.first { $0.type == .targetTiltAngle } as? GenericCharacteristic<Int>
			super.init(type: .slats, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class SmokeSensorBase: Service {
		// Required Characteristics
		public let smokeDetected = PredefinedCharacteristic.smokeDetected()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [smokeDetected]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			statusActive = unwrappedOptionalCharacteristics.first { $0.type == .statusActive } as? GenericCharacteristic<Bool>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			statusLowBattery = unwrappedOptionalCharacteristics.first { $0.type == .statusLowBattery } as? GenericCharacteristic<Enums.StatusLowBattery>
			statusTampered = unwrappedOptionalCharacteristics.first { $0.type == .statusTampered } as? GenericCharacteristic<UInt8>
			super.init(type: .smokeSensor, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class SpeakerBase: Service {
		// Required Characteristics
		public let mute = PredefinedCharacteristic.mute()

		// Optional Characteristics
		public let active: GenericCharacteristic<Enums.Active>?
		public let volume: GenericCharacteristic<Int>?
		public let volumeControlType: GenericCharacteristic<Enums.VolumeControlType>?
		public let volumeSelector: GenericCharacteristic<Enums.VolumeSelector>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [mute]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			active = unwrappedOptionalCharacteristics.first { $0.type == .active } as? GenericCharacteristic<Enums.Active>
			volume = unwrappedOptionalCharacteristics.first { $0.type == .volume } as? GenericCharacteristic<Int>
			volumeControlType = unwrappedOptionalCharacteristics.first { $0.type == .volumeControlType } as? GenericCharacteristic<Enums.VolumeControlType>
			volumeSelector = unwrappedOptionalCharacteristics.first { $0.type == .volumeSelector } as? GenericCharacteristic<Enums.VolumeSelector>
			super.init(type: .speaker, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class StatefulProgrammableSwitchBase: Service {
		// Required Characteristics
		public let programmableSwitchEvent = PredefinedCharacteristic.programmableSwitchEvent()
		public let programmableSwitchOutputState = PredefinedCharacteristic.programmableSwitchOutputState()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [programmableSwitchEvent, programmableSwitchOutputState]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			super.init(type: .statefulProgrammableSwitch, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class StatelessProgrammableSwitchBase: Service {
		// Required Characteristics
		public let programmableSwitchEvent = PredefinedCharacteristic.programmableSwitchEvent()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let labelIndex: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [programmableSwitchEvent]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			labelIndex = unwrappedOptionalCharacteristics.first { $0.type == .labelIndex } as? GenericCharacteristic<UInt8>
			super.init(type: .statelessProgrammableSwitch, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class SwitchBase: Service {
		// Required Characteristics
		public let powerState = PredefinedCharacteristic.powerState()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [powerState]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			super.init(type: .`switch`, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class TelevisionBase: Service {
		// Required Characteristics
		public let active = PredefinedCharacteristic.active()
		public let activeIdentifier = PredefinedCharacteristic.activeIdentifier()
		public let configuredName = PredefinedCharacteristic.configuredName()
		public let sleepDiscoveryMode = PredefinedCharacteristic.sleepDiscoveryMode()

		// Optional Characteristics
		public let brightness: GenericCharacteristic<Int>?
		public let closedCaptions: GenericCharacteristic<Enums.ClosedCaptions>?
		public let mediaState: GenericCharacteristic<UInt8>?
		public let pictureMode: GenericCharacteristic<Enums.PictureMode>?
		public let powerMode: GenericCharacteristic<UInt8>?
		public let powerModeSelection: GenericCharacteristic<Enums.PowerModeSelection>?
		public let remoteKey: GenericCharacteristic<Enums.RemoteKey>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [active, activeIdentifier, configuredName, sleepDiscoveryMode]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			brightness = unwrappedOptionalCharacteristics.first { $0.type == .brightness } as? GenericCharacteristic<Int>
			closedCaptions = unwrappedOptionalCharacteristics.first { $0.type == .closedCaptions } as? GenericCharacteristic<Enums.ClosedCaptions>
			mediaState = unwrappedOptionalCharacteristics.first { $0.type == .mediaState } as? GenericCharacteristic<UInt8>
			pictureMode = unwrappedOptionalCharacteristics.first { $0.type == .pictureMode } as? GenericCharacteristic<Enums.PictureMode>
			powerMode = unwrappedOptionalCharacteristics.first { $0.type == .powerMode } as? GenericCharacteristic<UInt8>
			powerModeSelection = unwrappedOptionalCharacteristics.first { $0.type == .powerModeSelection } as? GenericCharacteristic<Enums.PowerModeSelection>
			remoteKey = unwrappedOptionalCharacteristics.first { $0.type == .remoteKey } as? GenericCharacteristic<Enums.RemoteKey>
			super.init(type: .television, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class TemperatureSensorBase: Service {
		// Required Characteristics
		public let currentTemperature = PredefinedCharacteristic.currentTemperature()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [currentTemperature]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			statusActive = unwrappedOptionalCharacteristics.first { $0.type == .statusActive } as? GenericCharacteristic<Bool>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			statusLowBattery = unwrappedOptionalCharacteristics.first { $0.type == .statusLowBattery } as? GenericCharacteristic<Enums.StatusLowBattery>
			statusTampered = unwrappedOptionalCharacteristics.first { $0.type == .statusTampered } as? GenericCharacteristic<UInt8>
			super.init(type: .temperatureSensor, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class ThermostatBase: Service {
		// Required Characteristics
		public let currentHeatingCoolingState = PredefinedCharacteristic.currentHeatingCoolingState()
		public let targetHeatingCoolingState = PredefinedCharacteristic.targetHeatingCoolingState()
		public let currentTemperature = PredefinedCharacteristic.currentTemperature()
		public let targetTemperature = PredefinedCharacteristic.targetTemperature()
		public let temperatureDisplayUnits = PredefinedCharacteristic.temperatureDisplayUnits()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let currentRelativeHumidity: GenericCharacteristic<Float>?
		public let targetRelativeHumidity: GenericCharacteristic<Float>?
		public let coolingThresholdTemperature: GenericCharacteristic<Float>?
		public let heatingThresholdTemperature: GenericCharacteristic<Float>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [currentHeatingCoolingState, targetHeatingCoolingState, currentTemperature, targetTemperature, temperatureDisplayUnits]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			currentRelativeHumidity = unwrappedOptionalCharacteristics.first { $0.type == .currentRelativeHumidity } as? GenericCharacteristic<Float>
			targetRelativeHumidity = unwrappedOptionalCharacteristics.first { $0.type == .targetRelativeHumidity } as? GenericCharacteristic<Float>
			coolingThresholdTemperature = unwrappedOptionalCharacteristics.first { $0.type == .coolingThresholdTemperature } as? GenericCharacteristic<Float>
			heatingThresholdTemperature = unwrappedOptionalCharacteristics.first { $0.type == .heatingThresholdTemperature } as? GenericCharacteristic<Float>
			super.init(type: .thermostat, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class ValveBase: Service {
		// Required Characteristics
		public let active = PredefinedCharacteristic.active()
		public let inUse = PredefinedCharacteristic.inUse()
		public let valveType = PredefinedCharacteristic.valveType()

		// Optional Characteristics
		public let isConfigured: GenericCharacteristic<Enums.IsConfigured>?
		public let name: GenericCharacteristic<String>?
		public let remainingDuration: GenericCharacteristic<UInt32>?
		public let labelIndex: GenericCharacteristic<UInt8>?
		public let setDuration: GenericCharacteristic<UInt32>?
		public let statusFault: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [active, inUse, valveType]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			isConfigured = unwrappedOptionalCharacteristics.first { $0.type == .isConfigured } as? GenericCharacteristic<Enums.IsConfigured>
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			remainingDuration = unwrappedOptionalCharacteristics.first { $0.type == .remainingDuration } as? GenericCharacteristic<UInt32>
			labelIndex = unwrappedOptionalCharacteristics.first { $0.type == .labelIndex } as? GenericCharacteristic<UInt8>
			setDuration = unwrappedOptionalCharacteristics.first { $0.type == .setDuration } as? GenericCharacteristic<UInt32>
			statusFault = unwrappedOptionalCharacteristics.first { $0.type == .statusFault } as? GenericCharacteristic<UInt8>
			super.init(type: .valve, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class WindowBase: Service {
		// Required Characteristics
		public let currentPosition = PredefinedCharacteristic.currentPosition()
		public let positionState = PredefinedCharacteristic.positionState()
		public let targetPosition = PredefinedCharacteristic.targetPosition()

		// Optional Characteristics
		public let name: GenericCharacteristic<String>?
		public let obstructionDetected: GenericCharacteristic<Bool>?
		public let holdPosition: GenericCharacteristic<Bool>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [currentPosition, positionState, targetPosition]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			obstructionDetected = unwrappedOptionalCharacteristics.first { $0.type == .obstructionDetected } as? GenericCharacteristic<Bool>
			holdPosition = unwrappedOptionalCharacteristics.first { $0.type == .holdPosition } as? GenericCharacteristic<Bool>
			super.init(type: .window, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

	open class WindowCoveringBase: Service {
		// Required Characteristics
		public let currentPosition = PredefinedCharacteristic.currentPosition()
		public let positionState = PredefinedCharacteristic.positionState()
		public let targetPosition = PredefinedCharacteristic.targetPosition()

		// Optional Characteristics
		public let currentHorizontalTiltAngle: GenericCharacteristic<Int>?
		public let targetHorizontalTiltAngle: GenericCharacteristic<Int>?
		public let name: GenericCharacteristic<String>?
		public let obstructionDetected: GenericCharacteristic<Bool>?
		public let holdPosition: GenericCharacteristic<Bool>?
		public let currentVerticalTiltAngle: GenericCharacteristic<Int>?
		public let targetVerticalTiltAngle: GenericCharacteristic<Int>?

		public init(optionalCharacteristics: [AnyCharacteristic] = []) {
			let requiredCharacteristics: [Characteristic] = [currentPosition, positionState, targetPosition]
			let unwrappedOptionalCharacteristics = optionalCharacteristics.map { $0.wrapped }
			currentHorizontalTiltAngle = unwrappedOptionalCharacteristics.first { $0.type == .currentHorizontalTiltAngle } as? GenericCharacteristic<Int>
			targetHorizontalTiltAngle = unwrappedOptionalCharacteristics.first { $0.type == .targetHorizontalTiltAngle } as? GenericCharacteristic<Int>
			name = unwrappedOptionalCharacteristics.first { $0.type == .name } as? GenericCharacteristic<String>
			obstructionDetected = unwrappedOptionalCharacteristics.first { $0.type == .obstructionDetected } as? GenericCharacteristic<Bool>
			holdPosition = unwrappedOptionalCharacteristics.first { $0.type == .holdPosition } as? GenericCharacteristic<Bool>
			currentVerticalTiltAngle = unwrappedOptionalCharacteristics.first { $0.type == .currentVerticalTiltAngle } as? GenericCharacteristic<Int>
			targetVerticalTiltAngle = unwrappedOptionalCharacteristics.first { $0.type == .targetVerticalTiltAngle } as? GenericCharacteristic<Int>
			super.init(type: .windowCovering, characteristics: requiredCharacteristics + unwrappedOptionalCharacteristics)
		}
	}

}

public extension AnyCharacteristic {
	public static func accessoryFlags(
		_ value: UInt32? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Accessory Flags",
		format: CharacteristicFormat? = .uint32,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.accessoryFlags(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func active(
		_ value: Enums.Active? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Active",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.active(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func activeIdentifier(
		_ value: UInt32? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Active Identifier",
		format: CharacteristicFormat? = .uint32,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = Optional(0),
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.activeIdentifier(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func administratorOnlyAccess(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Administrator Only Access",
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.administratorOnlyAccess(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func applicationMatchingIdentifier(
		_ value: Data? = nil,
		permissions: [CharacteristicPermission] = [.read],
		description: String? = "Application Matching Identifier",
		format: CharacteristicFormat? = .tlv8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.applicationMatchingIdentifier(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func audioFeedback(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Audio Feedback",
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.audioFeedback(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func batteryLevel(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Battery Level",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.batteryLevel(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func brightness(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Brightness",
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.brightness(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func carbonDioxideDetected(
		_ value: Enums.CarbonDioxideDetected? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Carbon dioxide Detected",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.carbonDioxideDetected(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func carbonDioxideLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Carbon dioxide Level",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .ppm,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.carbonDioxideLevel(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func carbonDioxidePeakLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Carbon dioxide Peak Level",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .ppm,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.carbonDioxidePeakLevel(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func carbonMonoxideDetected(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Carbon monoxide Detected",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.carbonMonoxideDetected(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func carbonMonoxideLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Carbon monoxide Level",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .ppm,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.carbonMonoxideLevel(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func carbonMonoxidePeakLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Carbon monoxide Peak Level",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .ppm,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.carbonMonoxidePeakLevel(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func chargingState(
		_ value: Enums.ChargingState? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Charging State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.chargingState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func closedCaptions(
		_ value: Enums.ClosedCaptions? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Closed Captions",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.closedCaptions(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func colorTemperature(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Color Temperature",
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(500),
		minValue: Double? = Optional(140),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.colorTemperature(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func configuredName(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Configured Name",
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.configuredName(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func contactSensorState(
		_ value: Enums.ContactSensorState? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Contact Sensor State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.contactSensorState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func coolingThresholdTemperature(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Cooling Threshold Temperature",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .celsius,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(35),
		minValue: Double? = Optional(10),
		minStep: Double? = Optional(0.1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.coolingThresholdTemperature(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentAirPurifierState(
		_ value: Enums.CurrentAirPurifierState? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Air Purifier State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentAirPurifierState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentAirQuality(
		_ value: Enums.CurrentAirQuality? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Air Quality",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(5),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentAirQuality(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentDoorState(
		_ value: Enums.CurrentDoorState? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Door State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(4),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentDoorState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentFanState(
		_ value: Enums.CurrentFanState? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Fan State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentFanState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentHeaterCoolerState(
		_ value: Enums.CurrentHeaterCoolerState? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Heater-Cooler State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentHeaterCoolerState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentHeatingCoolingState(
		_ value: Enums.CurrentHeatingCoolingState? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Heating Cooling State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentHeatingCoolingState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentHorizontalTiltAngle(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Horizontal Tilt Angle",
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(90),
		minValue: Double? = Optional(-90),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentHorizontalTiltAngle(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentHumidifierDehumidifierState(
		_ value: Enums.CurrentHumidifierDehumidifierState? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Humidifier-Dehumidifier State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentHumidifierDehumidifierState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentLightLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Light Level",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .lux,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100000),
		minValue: Double? = Optional(0.0001),
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentLightLevel(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentPosition(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Position",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentPosition(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentRelativeHumidity(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Relative Humidity",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentRelativeHumidity(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentSlatState(
		_ value: Enums.CurrentSlatState? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Slat State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentSlatState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentTemperature(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Temperature",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .celsius,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(0.1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentTemperature(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentTiltAngle(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Tilt Angle",
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(90),
		minValue: Double? = Optional(-90),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentTiltAngle(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentVerticalTiltAngle(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Vertical Tilt Angle",
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(90),
		minValue: Double? = Optional(-90),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentVerticalTiltAngle(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func currentWaterLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Current Water Level",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.currentWaterLevel(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func filterChangeIndication(
		_ value: Enums.FilterChangeIndication? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Filter Change indication",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.filterChangeIndication(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func filterLifeLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Filter Life Level",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.filterLifeLevel(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func filterResetChangeIndication(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.write],
		description: String? = "Filter Reset Change Indication",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(1),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.filterResetChangeIndication(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func firmwareRevision(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read],
		description: String? = "Firmware Revision",
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.firmwareRevision(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func hardwareRevision(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read],
		description: String? = "Hardware Revision",
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.hardwareRevision(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func heatingThresholdTemperature(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Heating Threshold Temperature",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .celsius,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(25),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(0.1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.heatingThresholdTemperature(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func holdPosition(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.write],
		description: String? = "Hold Position",
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.holdPosition(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func hue(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Hue",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(360),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.hue(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func identifier(
		_ value: UInt32? = nil,
		permissions: [CharacteristicPermission] = [.read],
		description: String? = "Identifier",
		format: CharacteristicFormat? = .uint32,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = Optional(0),
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.identifier(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func identify(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.write],
		description: String? = "Identify",
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.identify(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func inUse(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "In Use",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.inUse(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func inputDeviceType(
		_ value: Enums.InputDeviceType? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Input Device Type",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(5),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.inputDeviceType(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func inputSourceType(
		_ value: Enums.InputSourceType? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Input Source Type",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(10),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.inputSourceType(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func isConfigured(
		_ value: Enums.IsConfigured? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Is Configured",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.isConfigured(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func isHidden(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Is Hidden",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.isHidden(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func labelIndex(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read],
		description: String? = "Label Index",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(255),
		minValue: Double? = Optional(1),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.labelIndex(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func labelNamespace(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read],
		description: String? = "Label Namespace",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(4),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.labelNamespace(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func leakDetected(
		_ value: Enums.LeakDetected? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Leak Detected",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.leakDetected(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func lockControlPoint(
		_ value: Data? = nil,
		permissions: [CharacteristicPermission] = [.write],
		description: String? = "Lock Control Point",
		format: CharacteristicFormat? = .tlv8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.lockControlPoint(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func lockCurrentState(
		_ value: Enums.LockCurrentState? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Lock Current State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.lockCurrentState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func lockLastKnownAction(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Lock Last Known Action",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(8),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.lockLastKnownAction(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func lockManagementAutoSecurityTimeout(
		_ value: UInt32? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Lock Management Auto Security Timeout",
		format: CharacteristicFormat? = .uint32,
		unit: CharacteristicUnit? = .seconds,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.lockManagementAutoSecurityTimeout(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func lockPhysicalControls(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Lock Physical Controls",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.lockPhysicalControls(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func lockTargetState(
		_ value: Enums.LockTargetState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Lock Target State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.lockTargetState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func logs(
		_ value: Data? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Logs",
		format: CharacteristicFormat? = .tlv8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.logs(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func manufacturer(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read],
		description: String? = "Manufacturer",
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.manufacturer(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func mediaState(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Media State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.mediaState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func model(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read],
		description: String? = "Model",
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.model(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func motionDetected(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Motion Detected",
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.motionDetected(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func mute(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Mute",
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.mute(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func name(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read],
		description: String? = "Name",
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.name(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func nitrogenDioxideDensity(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Nitrogen dioxide Density",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .microgramsPerMCubed,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.nitrogenDioxideDensity(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func obstructionDetected(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Obstruction Detected",
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.obstructionDetected(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func occupancyDetected(
		_ value: Enums.OccupancyDetected? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Occupancy Detected",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.occupancyDetected(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func outletInUse(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Outlet In Use",
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.outletInUse(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func ozoneDensity(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Ozone Density",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .microgramsPerMCubed,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.ozoneDensity(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func pm10Density(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "PM10 Density",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .microgramsPerMCubed,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.pm10Density(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func pm2_5Density(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "PM2.5 Density",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .microgramsPerMCubed,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.pm2_5Density(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func pictureMode(
		_ value: Enums.PictureMode? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Picture Mode",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(7),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.pictureMode(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func positionState(
		_ value: Enums.PositionState? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Position State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.positionState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func powerMode(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Power Mode",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.powerMode(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func powerModeSelection(
		_ value: Enums.PowerModeSelection? = nil,
		permissions: [CharacteristicPermission] = [.write],
		description: String? = "Power Mode Selection",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.powerModeSelection(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func powerState(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Power State",
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.powerState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func programMode(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Program Mode",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.programMode(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func programmableSwitchEvent(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Programmable Switch Event",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.programmableSwitchEvent(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func programmableSwitchOutputState(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Programmable Switch Output State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.programmableSwitchOutputState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func relativeHumidityDehumidifierThreshold(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Relative Humidity Dehumidifier Threshold",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.relativeHumidityDehumidifierThreshold(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func relativeHumidityHumidifierThreshold(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Relative Humidity Humidifier Threshold",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.relativeHumidityHumidifierThreshold(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func remainingDuration(
		_ value: UInt32? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Remaining Duration",
		format: CharacteristicFormat? = .uint32,
		unit: CharacteristicUnit? = .seconds,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3600),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.remainingDuration(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func remoteKey(
		_ value: Enums.RemoteKey? = nil,
		permissions: [CharacteristicPermission] = [.write],
		description: String? = "Remote Key",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(11),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.remoteKey(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func rotationDirection(
		_ value: Enums.RotationDirection? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Rotation Direction",
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.rotationDirection(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func rotationSpeed(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Rotation Speed",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.rotationSpeed(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func saturation(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Saturation",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.saturation(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func securitySystemAlarmType(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Security System Alarm Type",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.securitySystemAlarmType(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func securitySystemCurrentState(
		_ value: Enums.SecuritySystemCurrentState? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Security System Current State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(4),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.securitySystemCurrentState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func securitySystemTargetState(
		_ value: Enums.SecuritySystemTargetState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Security System Target State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.securitySystemTargetState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func serialNumber(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read],
		description: String? = "Serial Number",
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.serialNumber(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func setDuration(
		_ value: UInt32? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Set Duration",
		format: CharacteristicFormat? = .uint32,
		unit: CharacteristicUnit? = .seconds,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3600),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.setDuration(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func slatType(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read],
		description: String? = "Slat Type",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.slatType(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func sleepDiscoveryMode(
		_ value: Enums.SleepDiscoveryMode? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Sleep Discovery Mode",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.sleepDiscoveryMode(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func smokeDetected(
		_ value: Enums.SmokeDetected? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Smoke Detected",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.smokeDetected(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func softwareRevision(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read],
		description: String? = "Software Revision",
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.softwareRevision(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func statusActive(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Status Active",
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.statusActive(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func statusFault(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Status Fault",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.statusFault(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func statusLowBattery(
		_ value: Enums.StatusLowBattery? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Status Low Battery",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.statusLowBattery(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func statusTampered(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Status Tampered",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.statusTampered(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func sulphurDioxideDensity(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Sulphur dioxide Density",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .microgramsPerMCubed,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.sulphurDioxideDensity(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func swingMode(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Swing Mode",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.swingMode(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func targetAirPurifierState(
		_ value: Enums.TargetAirPurifierState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Target Air Purifier State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.targetAirPurifierState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func targetDoorState(
		_ value: Enums.TargetDoorState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Target Door State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.targetDoorState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func targetFanState(
		_ value: Enums.TargetFanState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Target Fan State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.targetFanState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func targetHeaterCoolerState(
		_ value: Enums.TargetHeaterCoolerState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Target Heater-Cooler State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.targetHeaterCoolerState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func targetHeatingCoolingState(
		_ value: Enums.TargetHeatingCoolingState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Target Heating Cooling State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.targetHeatingCoolingState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func targetHorizontalTiltAngle(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Target Horizontal Tilt Angle",
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(90),
		minValue: Double? = Optional(-90),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.targetHorizontalTiltAngle(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func targetHumidifierDehumidifierState(
		_ value: Enums.TargetHumidifierDehumidifierState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Target Humidifier-Dehumidifier State",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.targetHumidifierDehumidifierState(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func targetPosition(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Target Position",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.targetPosition(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func targetRelativeHumidity(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Target Relative Humidity",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.targetRelativeHumidity(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func targetTemperature(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Target Temperature",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .celsius,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(38),
		minValue: Double? = Optional(10),
		minStep: Double? = Optional(0.1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.targetTemperature(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func targetTiltAngle(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Target Tilt Angle",
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(90),
		minValue: Double? = Optional(-90),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.targetTiltAngle(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func targetVerticalTiltAngle(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Target Vertical Tilt Angle",
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(90),
		minValue: Double? = Optional(-90),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.targetVerticalTiltAngle(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func temperatureDisplayUnits(
		_ value: Enums.TemperatureDisplayUnits? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Temperature Display Units",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.temperatureDisplayUnits(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func valveType(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Valve Type",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.valveType(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func version(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Version",
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.version(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func volatileOrganicCompoundDensity(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Volatile Organic Compound Density",
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .microgramsPerMCubed,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.volatileOrganicCompoundDensity(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func volume(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = "Volume",
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.volume(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func volumeControlType(
		_ value: Enums.VolumeControlType? = nil,
		permissions: [CharacteristicPermission] = [.read, .events],
		description: String? = "Volume Control Type",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.volumeControlType(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

	public static func volumeSelector(
		_ value: Enums.VolumeSelector? = nil,
		permissions: [CharacteristicPermission] = [.write],
		description: String? = "Volume Selector",
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> AnyCharacteristic {
		return AnyCharacteristic(
			PredefinedCharacteristic.volumeSelector(
				value,
				permissions: permissions,
				description: description,
				format: format,
				unit: unit,
				maxLength: maxLength,
				maxValue: maxValue,
				minValue: minValue,
				minStep: minStep)
			as Characteristic)
	}

}

public class PredefinedCharacteristic {
	static func accessoryFlags(
		_ value: UInt32? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint32,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<UInt32> {
		return GenericCharacteristic<UInt32>(
			type: .accessoryFlags,
			permissions: [.read, .events],
			description: "Accessory Flags")
	}

	static func active(
		_ value: Enums.Active? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.Active> {
		return GenericCharacteristic<Enums.Active>(
			type: .active,
			description: "Active",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func activeIdentifier(
		_ value: UInt32? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint32,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = Optional(0),
		minStep: Double? = nil
	) -> GenericCharacteristic<UInt32> {
		return GenericCharacteristic<UInt32>(
			type: .activeIdentifier,
			description: "Active Identifier",
			minValue: 0)
	}

	static func administratorOnlyAccess(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<Bool> {
		return GenericCharacteristic<Bool>(
			type: .administratorOnlyAccess,
			description: "Administrator Only Access")
	}

	static func applicationMatchingIdentifier(
		_ value: Data? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .tlv8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<Data> {
		return GenericCharacteristic<Data>(
			type: .applicationMatchingIdentifier,
			permissions: [.read],
			description: "Application Matching Identifier")
	}

	static func audioFeedback(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<Bool> {
		return GenericCharacteristic<Bool>(
			type: .audioFeedback,
			description: "Audio Feedback")
	}

	static func batteryLevel(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .batteryLevel,
			permissions: [.read, .events],
			description: "Battery Level",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func brightness(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Int> {
		return GenericCharacteristic<Int>(
			type: .brightness,
			description: "Brightness",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func carbonDioxideDetected(
		_ value: Enums.CarbonDioxideDetected? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.CarbonDioxideDetected> {
		return GenericCharacteristic<Enums.CarbonDioxideDetected>(
			type: .carbonDioxideDetected,
			permissions: [.read, .events],
			description: "Carbon dioxide Detected",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func carbonDioxideLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .ppm,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .carbonDioxideLevel,
			permissions: [.read, .events],
			description: "Carbon dioxide Level",
			unit: .ppm,
			maxValue: 100000,
			minValue: 0,
			minStep: 1)
	}

	static func carbonDioxidePeakLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .ppm,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .carbonDioxidePeakLevel,
			permissions: [.read, .events],
			description: "Carbon dioxide Peak Level",
			unit: .ppm,
			maxValue: 100000,
			minValue: 0,
			minStep: 1)
	}

	static func carbonMonoxideDetected(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .carbonMonoxideDetected,
			permissions: [.read, .events],
			description: "Carbon monoxide Detected",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func carbonMonoxideLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .ppm,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .carbonMonoxideLevel,
			permissions: [.read, .events],
			description: "Carbon monoxide Level",
			unit: .ppm,
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func carbonMonoxidePeakLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .ppm,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .carbonMonoxidePeakLevel,
			permissions: [.read, .events],
			description: "Carbon monoxide Peak Level",
			unit: .ppm,
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func chargingState(
		_ value: Enums.ChargingState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.ChargingState> {
		return GenericCharacteristic<Enums.ChargingState>(
			type: .chargingState,
			permissions: [.read, .events],
			description: "Charging State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)
	}

	static func closedCaptions(
		_ value: Enums.ClosedCaptions? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.ClosedCaptions> {
		return GenericCharacteristic<Enums.ClosedCaptions>(
			type: .closedCaptions,
			description: "Closed Captions",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func colorTemperature(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(500),
		minValue: Double? = Optional(140),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Int> {
		return GenericCharacteristic<Int>(
			type: .colorTemperature,
			description: "Color Temperature",
			maxValue: 500,
			minValue: 140,
			minStep: 1)
	}

	static func configuredName(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<String> {
		return GenericCharacteristic<String>(
			type: .configuredName,
			description: "Configured Name")
	}

	static func contactSensorState(
		_ value: Enums.ContactSensorState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.ContactSensorState> {
		return GenericCharacteristic<Enums.ContactSensorState>(
			type: .contactSensorState,
			permissions: [.read, .events],
			description: "Contact Sensor State",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func coolingThresholdTemperature(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .celsius,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(35),
		minValue: Double? = Optional(10),
		minStep: Double? = Optional(0.1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .coolingThresholdTemperature,
			description: "Cooling Threshold Temperature",
			unit: .celsius,
			maxValue: 35,
			minValue: 10,
			minStep: 0.1)
	}

	static func currentAirPurifierState(
		_ value: Enums.CurrentAirPurifierState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.CurrentAirPurifierState> {
		return GenericCharacteristic<Enums.CurrentAirPurifierState>(
			type: .currentAirPurifierState,
			permissions: [.read, .events],
			description: "Current Air Purifier State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)
	}

	static func currentAirQuality(
		_ value: Enums.CurrentAirQuality? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(5),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.CurrentAirQuality> {
		return GenericCharacteristic<Enums.CurrentAirQuality>(
			type: .currentAirQuality,
			permissions: [.read, .events],
			description: "Current Air Quality",
			maxValue: 5,
			minValue: 0,
			minStep: 1)
	}

	static func currentDoorState(
		_ value: Enums.CurrentDoorState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(4),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.CurrentDoorState> {
		return GenericCharacteristic<Enums.CurrentDoorState>(
			type: .currentDoorState,
			permissions: [.read, .events],
			description: "Current Door State",
			maxValue: 4,
			minValue: 0,
			minStep: 1)
	}

	static func currentFanState(
		_ value: Enums.CurrentFanState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.CurrentFanState> {
		return GenericCharacteristic<Enums.CurrentFanState>(
			type: .currentFanState,
			permissions: [.read, .events],
			description: "Current Fan State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)
	}

	static func currentHeaterCoolerState(
		_ value: Enums.CurrentHeaterCoolerState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.CurrentHeaterCoolerState> {
		return GenericCharacteristic<Enums.CurrentHeaterCoolerState>(
			type: .currentHeaterCoolerState,
			permissions: [.read, .events],
			description: "Current Heater-Cooler State",
			maxValue: 3,
			minValue: 0,
			minStep: 1)
	}

	static func currentHeatingCoolingState(
		_ value: Enums.CurrentHeatingCoolingState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.CurrentHeatingCoolingState> {
		return GenericCharacteristic<Enums.CurrentHeatingCoolingState>(
			type: .currentHeatingCoolingState,
			permissions: [.read, .events],
			description: "Current Heating Cooling State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)
	}

	static func currentHorizontalTiltAngle(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(90),
		minValue: Double? = Optional(-90),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Int> {
		return GenericCharacteristic<Int>(
			type: .currentHorizontalTiltAngle,
			permissions: [.read, .events],
			description: "Current Horizontal Tilt Angle",
			unit: .arcdegrees,
			maxValue: 90,
			minValue: -90,
			minStep: 1)
	}

	static func currentHumidifierDehumidifierState(
		_ value: Enums.CurrentHumidifierDehumidifierState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.CurrentHumidifierDehumidifierState> {
		return GenericCharacteristic<Enums.CurrentHumidifierDehumidifierState>(
			type: .currentHumidifierDehumidifierState,
			permissions: [.read, .events],
			description: "Current Humidifier-Dehumidifier State",
			maxValue: 3,
			minValue: 0,
			minStep: 1)
	}

	static func currentLightLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .lux,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100000),
		minValue: Double? = Optional(0.0001),
		minStep: Double? = nil
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .currentLightLevel,
			permissions: [.read, .events],
			description: "Current Light Level",
			unit: .lux,
			maxValue: 100000,
			minValue: 0.0001)
	}

	static func currentPosition(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .currentPosition,
			permissions: [.read, .events],
			description: "Current Position",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func currentRelativeHumidity(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .currentRelativeHumidity,
			permissions: [.read, .events],
			description: "Current Relative Humidity",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func currentSlatState(
		_ value: Enums.CurrentSlatState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.CurrentSlatState> {
		return GenericCharacteristic<Enums.CurrentSlatState>(
			type: .currentSlatState,
			permissions: [.read, .events],
			description: "Current Slat State",
			maxValue: 3,
			minValue: 0,
			minStep: 1)
	}

	static func currentTemperature(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .celsius,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(0.1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .currentTemperature,
			permissions: [.read, .events],
			description: "Current Temperature",
			unit: .celsius,
			maxValue: 100,
			minValue: 0,
			minStep: 0.1)
	}

	static func currentTiltAngle(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(90),
		minValue: Double? = Optional(-90),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Int> {
		return GenericCharacteristic<Int>(
			type: .currentTiltAngle,
			permissions: [.read, .events],
			description: "Current Tilt Angle",
			unit: .arcdegrees,
			maxValue: 90,
			minValue: -90,
			minStep: 1)
	}

	static func currentVerticalTiltAngle(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(90),
		minValue: Double? = Optional(-90),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Int> {
		return GenericCharacteristic<Int>(
			type: .currentVerticalTiltAngle,
			permissions: [.read, .events],
			description: "Current Vertical Tilt Angle",
			unit: .arcdegrees,
			maxValue: 90,
			minValue: -90,
			minStep: 1)
	}

	static func currentWaterLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .currentWaterLevel,
			permissions: [.read, .events],
			description: "Current Water Level",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func filterChangeIndication(
		_ value: Enums.FilterChangeIndication? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.FilterChangeIndication> {
		return GenericCharacteristic<Enums.FilterChangeIndication>(
			type: .filterChangeIndication,
			permissions: [.read, .events],
			description: "Filter Change indication",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func filterLifeLevel(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .filterLifeLevel,
			permissions: [.read, .events],
			description: "Filter Life Level",
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func filterResetChangeIndication(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(1),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .filterResetChangeIndication,
			permissions: [.write],
			description: "Filter Reset Change Indication",
			maxValue: 1,
			minValue: 1,
			minStep: 1)
	}

	static func firmwareRevision(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<String> {
		return GenericCharacteristic<String>(
			type: .firmwareRevision,
			permissions: [.read],
			description: "Firmware Revision")
	}

	static func hardwareRevision(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<String> {
		return GenericCharacteristic<String>(
			type: .hardwareRevision,
			permissions: [.read],
			description: "Hardware Revision")
	}

	static func heatingThresholdTemperature(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .celsius,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(25),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(0.1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .heatingThresholdTemperature,
			description: "Heating Threshold Temperature",
			unit: .celsius,
			maxValue: 25,
			minValue: 0,
			minStep: 0.1)
	}

	static func holdPosition(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<Bool> {
		return GenericCharacteristic<Bool>(
			type: .holdPosition,
			permissions: [.write],
			description: "Hold Position")
	}

	static func hue(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(360),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .hue,
			description: "Hue",
			unit: .arcdegrees,
			maxValue: 360,
			minValue: 0,
			minStep: 1)
	}

	static func identifier(
		_ value: UInt32? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint32,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = Optional(0),
		minStep: Double? = nil
	) -> GenericCharacteristic<UInt32> {
		return GenericCharacteristic<UInt32>(
			type: .identifier,
			permissions: [.read],
			description: "Identifier",
			minValue: 0)
	}

	static func identify(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<Bool> {
		return GenericCharacteristic<Bool>(
			type: .identify,
			permissions: [.write],
			description: "Identify")
	}

	static func inUse(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .inUse,
			permissions: [.read, .events],
			description: "In Use",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func inputDeviceType(
		_ value: Enums.InputDeviceType? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(5),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.InputDeviceType> {
		return GenericCharacteristic<Enums.InputDeviceType>(
			type: .inputDeviceType,
			permissions: [.read, .events],
			description: "Input Device Type",
			maxValue: 5,
			minValue: 0,
			minStep: 1)
	}

	static func inputSourceType(
		_ value: Enums.InputSourceType? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(10),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.InputSourceType> {
		return GenericCharacteristic<Enums.InputSourceType>(
			type: .inputSourceType,
			permissions: [.read, .events],
			description: "Input Source Type",
			maxValue: 10,
			minValue: 0,
			minStep: 1)
	}

	static func isConfigured(
		_ value: Enums.IsConfigured? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.IsConfigured> {
		return GenericCharacteristic<Enums.IsConfigured>(
			type: .isConfigured,
			description: "Is Configured",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func isHidden(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .isHidden,
			description: "Is Hidden",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func labelIndex(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(255),
		minValue: Double? = Optional(1),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .labelIndex,
			permissions: [.read],
			description: "Label Index",
			maxValue: 255,
			minValue: 1,
			minStep: 1)
	}

	static func labelNamespace(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(4),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .labelNamespace,
			permissions: [.read],
			description: "Label Namespace",
			maxValue: 4,
			minValue: 0,
			minStep: 1)
	}

	static func leakDetected(
		_ value: Enums.LeakDetected? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.LeakDetected> {
		return GenericCharacteristic<Enums.LeakDetected>(
			type: .leakDetected,
			permissions: [.read, .events],
			description: "Leak Detected",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func lockControlPoint(
		_ value: Data? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .tlv8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<Data> {
		return GenericCharacteristic<Data>(
			type: .lockControlPoint,
			permissions: [.write],
			description: "Lock Control Point")
	}

	static func lockCurrentState(
		_ value: Enums.LockCurrentState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.LockCurrentState> {
		return GenericCharacteristic<Enums.LockCurrentState>(
			type: .lockCurrentState,
			permissions: [.read, .events],
			description: "Lock Current State",
			maxValue: 3,
			minValue: 0,
			minStep: 1)
	}

	static func lockLastKnownAction(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(8),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .lockLastKnownAction,
			permissions: [.read, .events],
			description: "Lock Last Known Action",
			maxValue: 8,
			minValue: 0,
			minStep: 1)
	}

	static func lockManagementAutoSecurityTimeout(
		_ value: UInt32? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint32,
		unit: CharacteristicUnit? = .seconds,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<UInt32> {
		return GenericCharacteristic<UInt32>(
			type: .lockManagementAutoSecurityTimeout,
			description: "Lock Management Auto Security Timeout",
			unit: .seconds)
	}

	static func lockPhysicalControls(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .lockPhysicalControls,
			description: "Lock Physical Controls",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func lockTargetState(
		_ value: Enums.LockTargetState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.LockTargetState> {
		return GenericCharacteristic<Enums.LockTargetState>(
			type: .lockTargetState,
			description: "Lock Target State",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func logs(
		_ value: Data? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .tlv8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<Data> {
		return GenericCharacteristic<Data>(
			type: .logs,
			permissions: [.read, .events],
			description: "Logs")
	}

	static func manufacturer(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<String> {
		return GenericCharacteristic<String>(
			type: .manufacturer,
			permissions: [.read],
			description: "Manufacturer")
	}

	static func mediaState(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .mediaState,
			description: "Media State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)
	}

	static func model(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<String> {
		return GenericCharacteristic<String>(
			type: .model,
			permissions: [.read],
			description: "Model")
	}

	static func motionDetected(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<Bool> {
		return GenericCharacteristic<Bool>(
			type: .motionDetected,
			permissions: [.read, .events],
			description: "Motion Detected")
	}

	static func mute(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<Bool> {
		return GenericCharacteristic<Bool>(
			type: .mute,
			description: "Mute")
	}

	static func name(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<String> {
		return GenericCharacteristic<String>(
			type: .name,
			permissions: [.read],
			description: "Name")
	}

	static func nitrogenDioxideDensity(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .microgramsPerMCubed,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .nitrogenDioxideDensity,
			permissions: [.read, .events],
			description: "Nitrogen dioxide Density",
			unit: .microgramsPerMCubed,
			maxValue: 1000,
			minValue: 0,
			minStep: 1)
	}

	static func obstructionDetected(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<Bool> {
		return GenericCharacteristic<Bool>(
			type: .obstructionDetected,
			permissions: [.read, .events],
			description: "Obstruction Detected")
	}

	static func occupancyDetected(
		_ value: Enums.OccupancyDetected? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.OccupancyDetected> {
		return GenericCharacteristic<Enums.OccupancyDetected>(
			type: .occupancyDetected,
			permissions: [.read, .events],
			description: "Occupancy Detected",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func outletInUse(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<Bool> {
		return GenericCharacteristic<Bool>(
			type: .outletInUse,
			permissions: [.read, .events],
			description: "Outlet In Use")
	}

	static func ozoneDensity(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .microgramsPerMCubed,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .ozoneDensity,
			permissions: [.read, .events],
			description: "Ozone Density",
			unit: .microgramsPerMCubed,
			maxValue: 1000,
			minValue: 0,
			minStep: 1)
	}

	static func pm10Density(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .microgramsPerMCubed,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .pm10Density,
			permissions: [.read, .events],
			description: "PM10 Density",
			unit: .microgramsPerMCubed,
			maxValue: 1000,
			minValue: 0,
			minStep: 1)
	}

	static func pm2_5Density(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .microgramsPerMCubed,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .pm2_5Density,
			permissions: [.read, .events],
			description: "PM2.5 Density",
			unit: .microgramsPerMCubed,
			maxValue: 1000,
			minValue: 0,
			minStep: 1)
	}

	static func pictureMode(
		_ value: Enums.PictureMode? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(7),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.PictureMode> {
		return GenericCharacteristic<Enums.PictureMode>(
			type: .pictureMode,
			description: "Picture Mode",
			maxValue: 7,
			minValue: 0,
			minStep: 1)
	}

	static func positionState(
		_ value: Enums.PositionState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.PositionState> {
		return GenericCharacteristic<Enums.PositionState>(
			type: .positionState,
			permissions: [.read, .events],
			description: "Position State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)
	}

	static func powerMode(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .powerMode,
			description: "Power Mode",
			maxValue: 3,
			minValue: 0,
			minStep: 1)
	}

	static func powerModeSelection(
		_ value: Enums.PowerModeSelection? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.PowerModeSelection> {
		return GenericCharacteristic<Enums.PowerModeSelection>(
			type: .powerModeSelection,
			permissions: [.write],
			description: "Power Mode Selection",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func powerState(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<Bool> {
		return GenericCharacteristic<Bool>(
			type: .powerState,
			description: "Power State")
	}

	static func programMode(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .programMode,
			permissions: [.read, .events],
			description: "Program Mode",
			maxValue: 2,
			minValue: 0,
			minStep: 1)
	}

	static func programmableSwitchEvent(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .programmableSwitchEvent,
			permissions: [.read, .events],
			description: "Programmable Switch Event",
			maxValue: 2,
			minValue: 0,
			minStep: 1)
	}

	static func programmableSwitchOutputState(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .programmableSwitchOutputState,
			description: "Programmable Switch Output State",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func relativeHumidityDehumidifierThreshold(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .relativeHumidityDehumidifierThreshold,
			description: "Relative Humidity Dehumidifier Threshold",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func relativeHumidityHumidifierThreshold(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .relativeHumidityHumidifierThreshold,
			description: "Relative Humidity Humidifier Threshold",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func remainingDuration(
		_ value: UInt32? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint32,
		unit: CharacteristicUnit? = .seconds,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3600),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt32> {
		return GenericCharacteristic<UInt32>(
			type: .remainingDuration,
			permissions: [.read, .events],
			description: "Remaining Duration",
			unit: .seconds,
			maxValue: 3600,
			minValue: 0,
			minStep: 1)
	}

	static func remoteKey(
		_ value: Enums.RemoteKey? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(11),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.RemoteKey> {
		return GenericCharacteristic<Enums.RemoteKey>(
			type: .remoteKey,
			permissions: [.write],
			description: "Remote Key",
			maxValue: 11,
			minValue: 0,
			minStep: 1)
	}

	static func rotationDirection(
		_ value: Enums.RotationDirection? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.RotationDirection> {
		return GenericCharacteristic<Enums.RotationDirection>(
			type: .rotationDirection,
			description: "Rotation Direction",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func rotationSpeed(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .rotationSpeed,
			description: "Rotation Speed",
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func saturation(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .saturation,
			description: "Saturation",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func securitySystemAlarmType(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .securitySystemAlarmType,
			permissions: [.read, .events],
			description: "Security System Alarm Type",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func securitySystemCurrentState(
		_ value: Enums.SecuritySystemCurrentState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(4),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.SecuritySystemCurrentState> {
		return GenericCharacteristic<Enums.SecuritySystemCurrentState>(
			type: .securitySystemCurrentState,
			permissions: [.read, .events],
			description: "Security System Current State",
			maxValue: 4,
			minValue: 0,
			minStep: 1)
	}

	static func securitySystemTargetState(
		_ value: Enums.SecuritySystemTargetState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.SecuritySystemTargetState> {
		return GenericCharacteristic<Enums.SecuritySystemTargetState>(
			type: .securitySystemTargetState,
			description: "Security System Target State",
			maxValue: 3,
			minValue: 0,
			minStep: 1)
	}

	static func serialNumber(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<String> {
		return GenericCharacteristic<String>(
			type: .serialNumber,
			permissions: [.read],
			description: "Serial Number")
	}

	static func setDuration(
		_ value: UInt32? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint32,
		unit: CharacteristicUnit? = .seconds,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3600),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt32> {
		return GenericCharacteristic<UInt32>(
			type: .setDuration,
			description: "Set Duration",
			unit: .seconds,
			maxValue: 3600,
			minValue: 0,
			minStep: 1)
	}

	static func slatType(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .slatType,
			permissions: [.read],
			description: "Slat Type",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func sleepDiscoveryMode(
		_ value: Enums.SleepDiscoveryMode? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.SleepDiscoveryMode> {
		return GenericCharacteristic<Enums.SleepDiscoveryMode>(
			type: .sleepDiscoveryMode,
			permissions: [.read, .events],
			description: "Sleep Discovery Mode",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func smokeDetected(
		_ value: Enums.SmokeDetected? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.SmokeDetected> {
		return GenericCharacteristic<Enums.SmokeDetected>(
			type: .smokeDetected,
			permissions: [.read, .events],
			description: "Smoke Detected",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func softwareRevision(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<String> {
		return GenericCharacteristic<String>(
			type: .softwareRevision,
			permissions: [.read],
			description: "Software Revision")
	}

	static func statusActive(
		_ value: Bool? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .bool,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<Bool> {
		return GenericCharacteristic<Bool>(
			type: .statusActive,
			permissions: [.read, .events],
			description: "Status Active")
	}

	static func statusFault(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .statusFault,
			permissions: [.read, .events],
			description: "Status Fault",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func statusLowBattery(
		_ value: Enums.StatusLowBattery? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.StatusLowBattery> {
		return GenericCharacteristic<Enums.StatusLowBattery>(
			type: .statusLowBattery,
			permissions: [.read, .events],
			description: "Status Low Battery",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func statusTampered(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .statusTampered,
			permissions: [.read, .events],
			description: "Status Tampered",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func sulphurDioxideDensity(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .microgramsPerMCubed,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .sulphurDioxideDensity,
			permissions: [.read, .events],
			description: "Sulphur dioxide Density",
			unit: .microgramsPerMCubed,
			maxValue: 1000,
			minValue: 0,
			minStep: 1)
	}

	static func swingMode(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .swingMode,
			description: "Swing Mode",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func targetAirPurifierState(
		_ value: Enums.TargetAirPurifierState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.TargetAirPurifierState> {
		return GenericCharacteristic<Enums.TargetAirPurifierState>(
			type: .targetAirPurifierState,
			description: "Target Air Purifier State",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func targetDoorState(
		_ value: Enums.TargetDoorState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.TargetDoorState> {
		return GenericCharacteristic<Enums.TargetDoorState>(
			type: .targetDoorState,
			description: "Target Door State",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func targetFanState(
		_ value: Enums.TargetFanState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.TargetFanState> {
		return GenericCharacteristic<Enums.TargetFanState>(
			type: .targetFanState,
			description: "Target Fan State",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func targetHeaterCoolerState(
		_ value: Enums.TargetHeaterCoolerState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.TargetHeaterCoolerState> {
		return GenericCharacteristic<Enums.TargetHeaterCoolerState>(
			type: .targetHeaterCoolerState,
			description: "Target Heater-Cooler State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)
	}

	static func targetHeatingCoolingState(
		_ value: Enums.TargetHeatingCoolingState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.TargetHeatingCoolingState> {
		return GenericCharacteristic<Enums.TargetHeatingCoolingState>(
			type: .targetHeatingCoolingState,
			description: "Target Heating Cooling State",
			maxValue: 3,
			minValue: 0,
			minStep: 1)
	}

	static func targetHorizontalTiltAngle(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(90),
		minValue: Double? = Optional(-90),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Int> {
		return GenericCharacteristic<Int>(
			type: .targetHorizontalTiltAngle,
			description: "Target Horizontal Tilt Angle",
			unit: .arcdegrees,
			maxValue: 90,
			minValue: -90,
			minStep: 1)
	}

	static func targetHumidifierDehumidifierState(
		_ value: Enums.TargetHumidifierDehumidifierState? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(2),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.TargetHumidifierDehumidifierState> {
		return GenericCharacteristic<Enums.TargetHumidifierDehumidifierState>(
			type: .targetHumidifierDehumidifierState,
			description: "Target Humidifier-Dehumidifier State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)
	}

	static func targetPosition(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .targetPosition,
			description: "Target Position",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func targetRelativeHumidity(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .targetRelativeHumidity,
			description: "Target Relative Humidity",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func targetTemperature(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .celsius,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(38),
		minValue: Double? = Optional(10),
		minStep: Double? = Optional(0.1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .targetTemperature,
			description: "Target Temperature",
			unit: .celsius,
			maxValue: 38,
			minValue: 10,
			minStep: 0.1)
	}

	static func targetTiltAngle(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(90),
		minValue: Double? = Optional(-90),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Int> {
		return GenericCharacteristic<Int>(
			type: .targetTiltAngle,
			description: "Target Tilt Angle",
			unit: .arcdegrees,
			maxValue: 90,
			minValue: -90,
			minStep: 1)
	}

	static func targetVerticalTiltAngle(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .arcdegrees,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(90),
		minValue: Double? = Optional(-90),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Int> {
		return GenericCharacteristic<Int>(
			type: .targetVerticalTiltAngle,
			description: "Target Vertical Tilt Angle",
			unit: .arcdegrees,
			maxValue: 90,
			minValue: -90,
			minStep: 1)
	}

	static func temperatureDisplayUnits(
		_ value: Enums.TemperatureDisplayUnits? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.TemperatureDisplayUnits> {
		return GenericCharacteristic<Enums.TemperatureDisplayUnits>(
			type: .temperatureDisplayUnits,
			description: "Temperature Display Units",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

	static func valveType(
		_ value: UInt8? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<UInt8> {
		return GenericCharacteristic<UInt8>(
			type: .valveType,
			permissions: [.read, .events],
			description: "Valve Type",
			maxValue: 3,
			minValue: 0,
			minStep: 1)
	}

	static func version(
		_ value: String? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .string,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = nil,
		minValue: Double? = nil,
		minStep: Double? = nil
	) -> GenericCharacteristic<String> {
		return GenericCharacteristic<String>(
			type: .version,
			permissions: [.read, .events],
			description: "Version")
	}

	static func volatileOrganicCompoundDensity(
		_ value: Float? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .float,
		unit: CharacteristicUnit? = .microgramsPerMCubed,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1000),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Float> {
		return GenericCharacteristic<Float>(
			type: .volatileOrganicCompoundDensity,
			permissions: [.read, .events],
			description: "Volatile Organic Compound Density",
			unit: .microgramsPerMCubed,
			maxValue: 1000,
			minValue: 0,
			minStep: 1)
	}

	static func volume(
		_ value: Int? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .int,
		unit: CharacteristicUnit? = .percentage,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(100),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Int> {
		return GenericCharacteristic<Int>(
			type: .volume,
			description: "Volume",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)
	}

	static func volumeControlType(
		_ value: Enums.VolumeControlType? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(3),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.VolumeControlType> {
		return GenericCharacteristic<Enums.VolumeControlType>(
			type: .volumeControlType,
			permissions: [.read, .events],
			description: "Volume Control Type",
			maxValue: 3,
			minValue: 0,
			minStep: 1)
	}

	static func volumeSelector(
		_ value: Enums.VolumeSelector? = nil,
		permissions: [CharacteristicPermission] = [.read, .write, .events],
		description: String? = nil,
		format: CharacteristicFormat? = .uint8,
		unit: CharacteristicUnit? = nil,
		maxLength: Int? = nil,
		maxValue: Double? = Optional(1),
		minValue: Double? = Optional(0),
		minStep: Double? = Optional(1)
	) -> GenericCharacteristic<Enums.VolumeSelector> {
		return GenericCharacteristic<Enums.VolumeSelector>(
			type: .volumeSelector,
			permissions: [.write],
			description: "Volume Selector",
			maxValue: 1,
			minValue: 0,
			minStep: 1)
	}

}
