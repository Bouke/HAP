// This file has been generated automatically from macOS HAP definitions.
// Don't make changes to this file, but regenerate using `hap-update` instead.
//
//  macOS: Version 10.14.4 (Build 18E184e)
//  date: 10 February 2019
//  HAP Version: 725
//

import Foundation

//
// HAP Accessory Categories
//

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

//
// HAP Service Types
//

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

//
// HAP Characteristic Types
//

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
	static let currentMediaState = CharacteristicType(0x00E0)
	static let currentPosition = CharacteristicType(0x006D)
	static let currentRelativeHumidity = CharacteristicType(0x0010)
	static let currentSlatState = CharacteristicType(0x00AA)
	static let currentTemperature = CharacteristicType(0x0011)
	static let currentTiltAngle = CharacteristicType(0x00C1)
	static let currentVerticalTiltAngle = CharacteristicType(0x006E)
	static let currentVisibilityState = CharacteristicType(0x0135)
	static let currentWaterLevel = CharacteristicType(0x00B5)
	static let displayOrder = CharacteristicType(0x0136)
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
	static let targetMediaState = CharacteristicType(0x0137)
	static let targetPosition = CharacteristicType(0x007C)
	static let targetRelativeHumidity = CharacteristicType(0x0034)
	static let targetTemperature = CharacteristicType(0x0035)
	static let targetTiltAngle = CharacteristicType(0x00C2)
	static let targetVerticalTiltAngle = CharacteristicType(0x007D)
	static let targetVisibilityState = CharacteristicType(0x0134)
	static let temperatureDisplayUnits = CharacteristicType(0x0036)
	static let valveType = CharacteristicType(0x00D5)
	static let version = CharacteristicType(0x0037)
	static let volatileOrganicCompoundDensity = CharacteristicType(0x00C8)
	static let volume = CharacteristicType(0x0119)
	static let volumeControlType = CharacteristicType(0x00E9)
	static let volumeSelector = CharacteristicType(0x00EA)
}

//
// HAP Characteristic Formats
//

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

//
// HAP Characteristic Units
//

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

///////////////////////////////////////////////////////////////////////////////

//
// HAP Enumerated types
//

public class HAP {

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

	public enum CurrentVisibilityState: UInt8, CharacteristicValueType {
		case shown = 0
		case hidden = 1
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
		case information = 15
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

	public enum TargetMediaState: UInt8, CharacteristicValueType {
		case play = 0
		case pause = 1
		case stop = 2
	}

	public enum TargetVisibilityState: UInt8, CharacteristicValueType {
		case shown = 0
		case hidden = 1
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

//
// HAP Service classes
//

extension Service {
	open class AirPurifierBase: Service {

		// Required Characteristics

		public let active = GenericCharacteristic<HAP.Active>(
			type: .active,
			description: "Active",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		public let currentAirPurifierState = GenericCharacteristic<HAP.CurrentAirPurifierState>(
			type: .currentAirPurifierState,
			permissions: [.read, .events],
			description: "Current Air Purifier State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)

		public let targetAirPurifierState = GenericCharacteristic<HAP.TargetAirPurifierState>(
			type: .targetAirPurifierState,
			description: "Target Air Purifier State",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let lockPhysicalControls: GenericCharacteristic<UInt8>?
		public let name: GenericCharacteristic<String>?
		public let rotationSpeed: GenericCharacteristic<Float>?
		public let swingMode: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [active, currentAirPurifierState, targetAirPurifierState]

			lockPhysicalControls = !optionalCharacteristics.contains(.lockPhysicalControls) ? nil :
				GenericCharacteristic<UInt8>(
				type: .lockPhysicalControls,
				description: "Lock Physical Controls",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let lockPhysicalControls = lockPhysicalControls {
				characteristics.append(lockPhysicalControls)
			}

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			rotationSpeed = !optionalCharacteristics.contains(.rotationSpeed) ? nil :
				GenericCharacteristic<Float>(
				type: .rotationSpeed,
				description: "Rotation Speed",
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let rotationSpeed = rotationSpeed {
				characteristics.append(rotationSpeed)
			}

			swingMode = !optionalCharacteristics.contains(.swingMode) ? nil :
				GenericCharacteristic<UInt8>(
				type: .swingMode,
				description: "Swing Mode",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let swingMode = swingMode {
				characteristics.append(swingMode)
			}

			super.init(type: .airPurifier, characteristics: characteristics)
		}
	}
}

extension Service {
	open class AirQualitySensorBase: Service {

		// Required Characteristics

		public let currentAirQuality = GenericCharacteristic<HAP.CurrentAirQuality>(
			type: .currentAirQuality,
			permissions: [.read, .events],
			description: "Current Air Quality",
			maxValue: 5,
			minValue: 0,
			minStep: 1)

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
		public let statusLowBattery: GenericCharacteristic<HAP.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [currentAirQuality]

			nitrogenDioxideDensity = !optionalCharacteristics.contains(.nitrogenDioxideDensity) ? nil :
				GenericCharacteristic<Float>(
				type: .nitrogenDioxideDensity,
				permissions: [.read, .events],
				description: "Nitrogen dioxide Density",
				unit: .microgramsPerMCubed,
				maxValue: 1000,
				minValue: 0,
				minStep: 1)

			if let nitrogenDioxideDensity = nitrogenDioxideDensity {
				characteristics.append(nitrogenDioxideDensity)
			}

			ozoneDensity = !optionalCharacteristics.contains(.ozoneDensity) ? nil :
				GenericCharacteristic<Float>(
				type: .ozoneDensity,
				permissions: [.read, .events],
				description: "Ozone Density",
				unit: .microgramsPerMCubed,
				maxValue: 1000,
				minValue: 0,
				minStep: 1)

			if let ozoneDensity = ozoneDensity {
				characteristics.append(ozoneDensity)
			}

			pm10Density = !optionalCharacteristics.contains(.pm10Density) ? nil :
				GenericCharacteristic<Float>(
				type: .pm10Density,
				permissions: [.read, .events],
				description: "PM10 Density",
				unit: .microgramsPerMCubed,
				maxValue: 1000,
				minValue: 0,
				minStep: 1)

			if let pm10Density = pm10Density {
				characteristics.append(pm10Density)
			}

			pm2_5Density = !optionalCharacteristics.contains(.pm2_5Density) ? nil :
				GenericCharacteristic<Float>(
				type: .pm2_5Density,
				permissions: [.read, .events],
				description: "PM2.5 Density",
				unit: .microgramsPerMCubed,
				maxValue: 1000,
				minValue: 0,
				minStep: 1)

			if let pm2_5Density = pm2_5Density {
				characteristics.append(pm2_5Density)
			}

			sulphurDioxideDensity = !optionalCharacteristics.contains(.sulphurDioxideDensity) ? nil :
				GenericCharacteristic<Float>(
				type: .sulphurDioxideDensity,
				permissions: [.read, .events],
				description: "Sulphur dioxide Density",
				unit: .microgramsPerMCubed,
				maxValue: 1000,
				minValue: 0,
				minStep: 1)

			if let sulphurDioxideDensity = sulphurDioxideDensity {
				characteristics.append(sulphurDioxideDensity)
			}

			volatileOrganicCompoundDensity = !optionalCharacteristics.contains(.volatileOrganicCompoundDensity) ? nil :
				GenericCharacteristic<Float>(
				type: .volatileOrganicCompoundDensity,
				permissions: [.read, .events],
				description: "Volatile Organic Compound Density",
				unit: .microgramsPerMCubed,
				maxValue: 1000,
				minValue: 0,
				minStep: 1)

			if let volatileOrganicCompoundDensity = volatileOrganicCompoundDensity {
				characteristics.append(volatileOrganicCompoundDensity)
			}

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			statusActive = !optionalCharacteristics.contains(.statusActive) ? nil :
				GenericCharacteristic<Bool>(
				type: .statusActive,
				permissions: [.read, .events],
				description: "Status Active")

			if let statusActive = statusActive {
				characteristics.append(statusActive)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			statusLowBattery = !optionalCharacteristics.contains(.statusLowBattery) ? nil :
				GenericCharacteristic<HAP.StatusLowBattery>(
				type: .statusLowBattery,
				permissions: [.read, .events],
				description: "Status Low Battery",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusLowBattery = statusLowBattery {
				characteristics.append(statusLowBattery)
			}

			statusTampered = !optionalCharacteristics.contains(.statusTampered) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusTampered,
				permissions: [.read, .events],
				description: "Status Tampered",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusTampered = statusTampered {
				characteristics.append(statusTampered)
			}

			super.init(type: .airQualitySensor, characteristics: characteristics)
		}
	}
}

extension Service {
	open class BatteryBase: Service {

		// Required Characteristics

		public let batteryLevel = GenericCharacteristic<UInt8>(
			type: .batteryLevel,
			permissions: [.read, .events],
			description: "Battery Level",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)

		public let chargingState = GenericCharacteristic<HAP.ChargingState>(
			type: .chargingState,
			permissions: [.read, .events],
			description: "Charging State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)

		public let statusLowBattery = GenericCharacteristic<HAP.StatusLowBattery>(
			type: .statusLowBattery,
			permissions: [.read, .events],
			description: "Status Low Battery",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [batteryLevel, chargingState, statusLowBattery]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			super.init(type: .battery, characteristics: characteristics)
		}
	}
}

extension Service {
	open class CarbonDioxideSensorBase: Service {

		// Required Characteristics

		public let carbonDioxideDetected = GenericCharacteristic<HAP.CarbonDioxideDetected>(
			type: .carbonDioxideDetected,
			permissions: [.read, .events],
			description: "Carbon dioxide Detected",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let carbonDioxideLevel: GenericCharacteristic<Float>?
		public let carbonDioxidePeakLevel: GenericCharacteristic<Float>?
		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<HAP.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [carbonDioxideDetected]

			carbonDioxideLevel = !optionalCharacteristics.contains(.carbonDioxideLevel) ? nil :
				GenericCharacteristic<Float>(
				type: .carbonDioxideLevel,
				permissions: [.read, .events],
				description: "Carbon dioxide Level",
				unit: .ppm,
				maxValue: 100000,
				minValue: 0,
				minStep: 1)

			if let carbonDioxideLevel = carbonDioxideLevel {
				characteristics.append(carbonDioxideLevel)
			}

			carbonDioxidePeakLevel = !optionalCharacteristics.contains(.carbonDioxidePeakLevel) ? nil :
				GenericCharacteristic<Float>(
				type: .carbonDioxidePeakLevel,
				permissions: [.read, .events],
				description: "Carbon dioxide Peak Level",
				unit: .ppm,
				maxValue: 100000,
				minValue: 0,
				minStep: 1)

			if let carbonDioxidePeakLevel = carbonDioxidePeakLevel {
				characteristics.append(carbonDioxidePeakLevel)
			}

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			statusActive = !optionalCharacteristics.contains(.statusActive) ? nil :
				GenericCharacteristic<Bool>(
				type: .statusActive,
				permissions: [.read, .events],
				description: "Status Active")

			if let statusActive = statusActive {
				characteristics.append(statusActive)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			statusLowBattery = !optionalCharacteristics.contains(.statusLowBattery) ? nil :
				GenericCharacteristic<HAP.StatusLowBattery>(
				type: .statusLowBattery,
				permissions: [.read, .events],
				description: "Status Low Battery",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusLowBattery = statusLowBattery {
				characteristics.append(statusLowBattery)
			}

			statusTampered = !optionalCharacteristics.contains(.statusTampered) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusTampered,
				permissions: [.read, .events],
				description: "Status Tampered",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusTampered = statusTampered {
				characteristics.append(statusTampered)
			}

			super.init(type: .carbonDioxideSensor, characteristics: characteristics)
		}
	}
}

extension Service {
	open class CarbonMonoxideSensorBase: Service {

		// Required Characteristics

		public let carbonMonoxideDetected = GenericCharacteristic<UInt8>(
			type: .carbonMonoxideDetected,
			permissions: [.read, .events],
			description: "Carbon monoxide Detected",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let carbonMonoxideLevel: GenericCharacteristic<Float>?
		public let carbonMonoxidePeakLevel: GenericCharacteristic<Float>?
		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<HAP.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [carbonMonoxideDetected]

			carbonMonoxideLevel = !optionalCharacteristics.contains(.carbonMonoxideLevel) ? nil :
				GenericCharacteristic<Float>(
				type: .carbonMonoxideLevel,
				permissions: [.read, .events],
				description: "Carbon monoxide Level",
				unit: .ppm,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let carbonMonoxideLevel = carbonMonoxideLevel {
				characteristics.append(carbonMonoxideLevel)
			}

			carbonMonoxidePeakLevel = !optionalCharacteristics.contains(.carbonMonoxidePeakLevel) ? nil :
				GenericCharacteristic<Float>(
				type: .carbonMonoxidePeakLevel,
				permissions: [.read, .events],
				description: "Carbon monoxide Peak Level",
				unit: .ppm,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let carbonMonoxidePeakLevel = carbonMonoxidePeakLevel {
				characteristics.append(carbonMonoxidePeakLevel)
			}

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			statusActive = !optionalCharacteristics.contains(.statusActive) ? nil :
				GenericCharacteristic<Bool>(
				type: .statusActive,
				permissions: [.read, .events],
				description: "Status Active")

			if let statusActive = statusActive {
				characteristics.append(statusActive)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			statusLowBattery = !optionalCharacteristics.contains(.statusLowBattery) ? nil :
				GenericCharacteristic<HAP.StatusLowBattery>(
				type: .statusLowBattery,
				permissions: [.read, .events],
				description: "Status Low Battery",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusLowBattery = statusLowBattery {
				characteristics.append(statusLowBattery)
			}

			statusTampered = !optionalCharacteristics.contains(.statusTampered) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusTampered,
				permissions: [.read, .events],
				description: "Status Tampered",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusTampered = statusTampered {
				characteristics.append(statusTampered)
			}

			super.init(type: .carbonMonoxideSensor, characteristics: characteristics)
		}
	}
}

extension Service {
	open class ContactSensorBase: Service {

		// Required Characteristics

		public let contactSensorState = GenericCharacteristic<HAP.ContactSensorState>(
			type: .contactSensorState,
			permissions: [.read, .events],
			description: "Contact Sensor State",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<HAP.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [contactSensorState]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			statusActive = !optionalCharacteristics.contains(.statusActive) ? nil :
				GenericCharacteristic<Bool>(
				type: .statusActive,
				permissions: [.read, .events],
				description: "Status Active")

			if let statusActive = statusActive {
				characteristics.append(statusActive)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			statusLowBattery = !optionalCharacteristics.contains(.statusLowBattery) ? nil :
				GenericCharacteristic<HAP.StatusLowBattery>(
				type: .statusLowBattery,
				permissions: [.read, .events],
				description: "Status Low Battery",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusLowBattery = statusLowBattery {
				characteristics.append(statusLowBattery)
			}

			statusTampered = !optionalCharacteristics.contains(.statusTampered) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusTampered,
				permissions: [.read, .events],
				description: "Status Tampered",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusTampered = statusTampered {
				characteristics.append(statusTampered)
			}

			super.init(type: .contactSensor, characteristics: characteristics)
		}
	}
}

extension Service {
	open class DoorBase: Service {

		// Required Characteristics

		public let currentPosition = GenericCharacteristic<UInt8>(
			type: .currentPosition,
			permissions: [.read, .events],
			description: "Current Position",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)

		public let positionState = GenericCharacteristic<HAP.PositionState>(
			type: .positionState,
			permissions: [.read, .events],
			description: "Position State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)

		public let targetPosition = GenericCharacteristic<UInt8>(
			type: .targetPosition,
			description: "Target Position",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let obstructionDetected: GenericCharacteristic<Bool>?
		public let holdPosition: GenericCharacteristic<Bool>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [currentPosition, positionState, targetPosition]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			obstructionDetected = !optionalCharacteristics.contains(.obstructionDetected) ? nil :
				GenericCharacteristic<Bool>(
				type: .obstructionDetected,
				permissions: [.read, .events],
				description: "Obstruction Detected")

			if let obstructionDetected = obstructionDetected {
				characteristics.append(obstructionDetected)
			}

			holdPosition = !optionalCharacteristics.contains(.holdPosition) ? nil :
				GenericCharacteristic<Bool>(
				type: .holdPosition,
				permissions: [.write],
				description: "Hold Position")

			if let holdPosition = holdPosition {
				characteristics.append(holdPosition)
			}

			super.init(type: .door, characteristics: characteristics)
		}
	}
}

extension Service {
	open class DoorbellBase: Service {

		// Required Characteristics

		public let programmableSwitchEvent = GenericCharacteristic<UInt8>(
			type: .programmableSwitchEvent,
			permissions: [.read, .events],
			description: "Programmable Switch Event",
			maxValue: 2,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let brightness: GenericCharacteristic<Int>?
		public let volume: GenericCharacteristic<Int>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [programmableSwitchEvent]

			brightness = !optionalCharacteristics.contains(.brightness) ? nil :
				GenericCharacteristic<Int>(
				type: .brightness,
				description: "Brightness",
				unit: .percentage,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let brightness = brightness {
				characteristics.append(brightness)
			}

			volume = !optionalCharacteristics.contains(.volume) ? nil :
				GenericCharacteristic<Int>(
				type: .volume,
				description: "Volume",
				unit: .percentage,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let volume = volume {
				characteristics.append(volume)
			}

			super.init(type: .doorbell, characteristics: characteristics)
		}
	}
}

extension Service {
	open class FanBase: Service {

		// Required Characteristics

		public let powerState = GenericCharacteristic<Bool>(
			type: .powerState,
			description: "Power State")

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let rotationDirection: GenericCharacteristic<HAP.RotationDirection>?
		public let rotationSpeed: GenericCharacteristic<Float>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [powerState]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			rotationDirection = !optionalCharacteristics.contains(.rotationDirection) ? nil :
				GenericCharacteristic<HAP.RotationDirection>(
				type: .rotationDirection,
				description: "Rotation Direction",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let rotationDirection = rotationDirection {
				characteristics.append(rotationDirection)
			}

			rotationSpeed = !optionalCharacteristics.contains(.rotationSpeed) ? nil :
				GenericCharacteristic<Float>(
				type: .rotationSpeed,
				description: "Rotation Speed",
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let rotationSpeed = rotationSpeed {
				characteristics.append(rotationSpeed)
			}

			super.init(type: .fan, characteristics: characteristics)
		}
	}
}

extension Service {
	open class FanV2Base: Service {

		// Required Characteristics

		public let active = GenericCharacteristic<HAP.Active>(
			type: .active,
			description: "Active",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let currentFanState: GenericCharacteristic<HAP.CurrentFanState>?
		public let targetFanState: GenericCharacteristic<HAP.TargetFanState>?
		public let lockPhysicalControls: GenericCharacteristic<UInt8>?
		public let name: GenericCharacteristic<String>?
		public let rotationDirection: GenericCharacteristic<HAP.RotationDirection>?
		public let rotationSpeed: GenericCharacteristic<Float>?
		public let swingMode: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [active]

			currentFanState = !optionalCharacteristics.contains(.currentFanState) ? nil :
				GenericCharacteristic<HAP.CurrentFanState>(
				type: .currentFanState,
				permissions: [.read, .events],
				description: "Current Fan State",
				maxValue: 2,
				minValue: 0,
				minStep: 1)

			if let currentFanState = currentFanState {
				characteristics.append(currentFanState)
			}

			targetFanState = !optionalCharacteristics.contains(.targetFanState) ? nil :
				GenericCharacteristic<HAP.TargetFanState>(
				type: .targetFanState,
				description: "Target Fan State",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let targetFanState = targetFanState {
				characteristics.append(targetFanState)
			}

			lockPhysicalControls = !optionalCharacteristics.contains(.lockPhysicalControls) ? nil :
				GenericCharacteristic<UInt8>(
				type: .lockPhysicalControls,
				description: "Lock Physical Controls",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let lockPhysicalControls = lockPhysicalControls {
				characteristics.append(lockPhysicalControls)
			}

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			rotationDirection = !optionalCharacteristics.contains(.rotationDirection) ? nil :
				GenericCharacteristic<HAP.RotationDirection>(
				type: .rotationDirection,
				description: "Rotation Direction",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let rotationDirection = rotationDirection {
				characteristics.append(rotationDirection)
			}

			rotationSpeed = !optionalCharacteristics.contains(.rotationSpeed) ? nil :
				GenericCharacteristic<Float>(
				type: .rotationSpeed,
				description: "Rotation Speed",
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let rotationSpeed = rotationSpeed {
				characteristics.append(rotationSpeed)
			}

			swingMode = !optionalCharacteristics.contains(.swingMode) ? nil :
				GenericCharacteristic<UInt8>(
				type: .swingMode,
				description: "Swing Mode",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let swingMode = swingMode {
				characteristics.append(swingMode)
			}

			super.init(type: .fanV2, characteristics: characteristics)
		}
	}
}

extension Service {
	open class FaucetBase: Service {

		// Required Characteristics

		public let active = GenericCharacteristic<HAP.Active>(
			type: .active,
			description: "Active",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let statusFault: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [active]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			super.init(type: .faucet, characteristics: characteristics)
		}
	}
}

extension Service {
	open class FilterMaintenanceBase: Service {

		// Required Characteristics

		public let filterChangeIndication = GenericCharacteristic<HAP.FilterChangeIndication>(
			type: .filterChangeIndication,
			permissions: [.read, .events],
			description: "Filter Change indication",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let filterLifeLevel: GenericCharacteristic<Float>?
		public let filterResetChangeIndication: GenericCharacteristic<UInt8>?
		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [filterChangeIndication]

			filterLifeLevel = !optionalCharacteristics.contains(.filterLifeLevel) ? nil :
				GenericCharacteristic<Float>(
				type: .filterLifeLevel,
				permissions: [.read, .events],
				description: "Filter Life Level",
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let filterLifeLevel = filterLifeLevel {
				characteristics.append(filterLifeLevel)
			}

			filterResetChangeIndication = !optionalCharacteristics.contains(.filterResetChangeIndication) ? nil :
				GenericCharacteristic<UInt8>(
				type: .filterResetChangeIndication,
				permissions: [.write],
				description: "Filter Reset Change Indication",
				maxValue: 1,
				minValue: 1,
				minStep: 1)

			if let filterResetChangeIndication = filterResetChangeIndication {
				characteristics.append(filterResetChangeIndication)
			}

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			super.init(type: .filterMaintenance, characteristics: characteristics)
		}
	}
}

extension Service {
	open class GarageDoorOpenerBase: Service {

		// Required Characteristics

		public let currentDoorState = GenericCharacteristic<HAP.CurrentDoorState>(
			type: .currentDoorState,
			permissions: [.read, .events],
			description: "Current Door State",
			maxValue: 4,
			minValue: 0,
			minStep: 1)

		public let targetDoorState = GenericCharacteristic<HAP.TargetDoorState>(
			type: .targetDoorState,
			description: "Target Door State",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		public let obstructionDetected = GenericCharacteristic<Bool>(
			type: .obstructionDetected,
			permissions: [.read, .events],
			description: "Obstruction Detected")

		// Optional Characteristics

		public let lockCurrentState: GenericCharacteristic<HAP.LockCurrentState>?
		public let lockTargetState: GenericCharacteristic<HAP.LockTargetState>?
		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [currentDoorState, targetDoorState, obstructionDetected]

			lockCurrentState = !optionalCharacteristics.contains(.lockCurrentState) ? nil :
				GenericCharacteristic<HAP.LockCurrentState>(
				type: .lockCurrentState,
				permissions: [.read, .events],
				description: "Lock Current State",
				maxValue: 3,
				minValue: 0,
				minStep: 1)

			if let lockCurrentState = lockCurrentState {
				characteristics.append(lockCurrentState)
			}

			lockTargetState = !optionalCharacteristics.contains(.lockTargetState) ? nil :
				GenericCharacteristic<HAP.LockTargetState>(
				type: .lockTargetState,
				description: "Lock Target State",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let lockTargetState = lockTargetState {
				characteristics.append(lockTargetState)
			}

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			super.init(type: .garageDoorOpener, characteristics: characteristics)
		}
	}
}

extension Service {
	open class HeaterCoolerBase: Service {

		// Required Characteristics

		public let active = GenericCharacteristic<HAP.Active>(
			type: .active,
			description: "Active",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		public let currentHeaterCoolerState = GenericCharacteristic<HAP.CurrentHeaterCoolerState>(
			type: .currentHeaterCoolerState,
			permissions: [.read, .events],
			description: "Current Heater-Cooler State",
			maxValue: 3,
			minValue: 0,
			minStep: 1)

		public let targetHeaterCoolerState = GenericCharacteristic<HAP.TargetHeaterCoolerState>(
			type: .targetHeaterCoolerState,
			description: "Target Heater-Cooler State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)

		public let currentTemperature = GenericCharacteristic<Float>(
			type: .currentTemperature,
			permissions: [.read, .events],
			description: "Current Temperature",
			unit: .celsius,
			maxValue: 100,
			minValue: 0,
			minStep: 0.1)

		// Optional Characteristics

		public let lockPhysicalControls: GenericCharacteristic<UInt8>?
		public let name: GenericCharacteristic<String>?
		public let rotationSpeed: GenericCharacteristic<Float>?
		public let swingMode: GenericCharacteristic<UInt8>?
		public let coolingThresholdTemperature: GenericCharacteristic<Float>?
		public let heatingThresholdTemperature: GenericCharacteristic<Float>?
		public let temperatureDisplayUnits: GenericCharacteristic<HAP.TemperatureDisplayUnits>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [active, currentHeaterCoolerState, targetHeaterCoolerState, currentTemperature]

			lockPhysicalControls = !optionalCharacteristics.contains(.lockPhysicalControls) ? nil :
				GenericCharacteristic<UInt8>(
				type: .lockPhysicalControls,
				description: "Lock Physical Controls",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let lockPhysicalControls = lockPhysicalControls {
				characteristics.append(lockPhysicalControls)
			}

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			rotationSpeed = !optionalCharacteristics.contains(.rotationSpeed) ? nil :
				GenericCharacteristic<Float>(
				type: .rotationSpeed,
				description: "Rotation Speed",
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let rotationSpeed = rotationSpeed {
				characteristics.append(rotationSpeed)
			}

			swingMode = !optionalCharacteristics.contains(.swingMode) ? nil :
				GenericCharacteristic<UInt8>(
				type: .swingMode,
				description: "Swing Mode",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let swingMode = swingMode {
				characteristics.append(swingMode)
			}

			coolingThresholdTemperature = !optionalCharacteristics.contains(.coolingThresholdTemperature) ? nil :
				GenericCharacteristic<Float>(
				type: .coolingThresholdTemperature,
				description: "Cooling Threshold Temperature",
				unit: .celsius,
				maxValue: 35,
				minValue: 10,
				minStep: 0.1)

			if let coolingThresholdTemperature = coolingThresholdTemperature {
				characteristics.append(coolingThresholdTemperature)
			}

			heatingThresholdTemperature = !optionalCharacteristics.contains(.heatingThresholdTemperature) ? nil :
				GenericCharacteristic<Float>(
				type: .heatingThresholdTemperature,
				description: "Heating Threshold Temperature",
				unit: .celsius,
				maxValue: 25,
				minValue: 0,
				minStep: 0.1)

			if let heatingThresholdTemperature = heatingThresholdTemperature {
				characteristics.append(heatingThresholdTemperature)
			}

			temperatureDisplayUnits = !optionalCharacteristics.contains(.temperatureDisplayUnits) ? nil :
				GenericCharacteristic<HAP.TemperatureDisplayUnits>(
				type: .temperatureDisplayUnits,
				description: "Temperature Display Units",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let temperatureDisplayUnits = temperatureDisplayUnits {
				characteristics.append(temperatureDisplayUnits)
			}

			super.init(type: .heaterCooler, characteristics: characteristics)
		}
	}
}

extension Service {
	open class HumidifierDehumidifierBase: Service {

		// Required Characteristics

		public let active = GenericCharacteristic<HAP.Active>(
			type: .active,
			description: "Active",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		public let currentHumidifierDehumidifierState = GenericCharacteristic<HAP.CurrentHumidifierDehumidifierState>(
			type: .currentHumidifierDehumidifierState,
			permissions: [.read, .events],
			description: "Current Humidifier-Dehumidifier State",
			maxValue: 3,
			minValue: 0,
			minStep: 1)

		public let targetHumidifierDehumidifierState = GenericCharacteristic<HAP.TargetHumidifierDehumidifierState>(
			type: .targetHumidifierDehumidifierState,
			description: "Target Humidifier-Dehumidifier State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)

		public let currentRelativeHumidity = GenericCharacteristic<Float>(
			type: .currentRelativeHumidity,
			permissions: [.read, .events],
			description: "Current Relative Humidity",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let lockPhysicalControls: GenericCharacteristic<UInt8>?
		public let name: GenericCharacteristic<String>?
		public let relativeHumidityDehumidifierThreshold: GenericCharacteristic<Float>?
		public let relativeHumidityHumidifierThreshold: GenericCharacteristic<Float>?
		public let rotationSpeed: GenericCharacteristic<Float>?
		public let swingMode: GenericCharacteristic<UInt8>?
		public let currentWaterLevel: GenericCharacteristic<Float>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [active, currentHumidifierDehumidifierState, targetHumidifierDehumidifierState, currentRelativeHumidity]

			lockPhysicalControls = !optionalCharacteristics.contains(.lockPhysicalControls) ? nil :
				GenericCharacteristic<UInt8>(
				type: .lockPhysicalControls,
				description: "Lock Physical Controls",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let lockPhysicalControls = lockPhysicalControls {
				characteristics.append(lockPhysicalControls)
			}

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			relativeHumidityDehumidifierThreshold = !optionalCharacteristics.contains(.relativeHumidityDehumidifierThreshold) ? nil :
				GenericCharacteristic<Float>(
				type: .relativeHumidityDehumidifierThreshold,
				description: "Relative Humidity Dehumidifier Threshold",
				unit: .percentage,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let relativeHumidityDehumidifierThreshold = relativeHumidityDehumidifierThreshold {
				characteristics.append(relativeHumidityDehumidifierThreshold)
			}

			relativeHumidityHumidifierThreshold = !optionalCharacteristics.contains(.relativeHumidityHumidifierThreshold) ? nil :
				GenericCharacteristic<Float>(
				type: .relativeHumidityHumidifierThreshold,
				description: "Relative Humidity Humidifier Threshold",
				unit: .percentage,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let relativeHumidityHumidifierThreshold = relativeHumidityHumidifierThreshold {
				characteristics.append(relativeHumidityHumidifierThreshold)
			}

			rotationSpeed = !optionalCharacteristics.contains(.rotationSpeed) ? nil :
				GenericCharacteristic<Float>(
				type: .rotationSpeed,
				description: "Rotation Speed",
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let rotationSpeed = rotationSpeed {
				characteristics.append(rotationSpeed)
			}

			swingMode = !optionalCharacteristics.contains(.swingMode) ? nil :
				GenericCharacteristic<UInt8>(
				type: .swingMode,
				description: "Swing Mode",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let swingMode = swingMode {
				characteristics.append(swingMode)
			}

			currentWaterLevel = !optionalCharacteristics.contains(.currentWaterLevel) ? nil :
				GenericCharacteristic<Float>(
				type: .currentWaterLevel,
				permissions: [.read, .events],
				description: "Current Water Level",
				unit: .percentage,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let currentWaterLevel = currentWaterLevel {
				characteristics.append(currentWaterLevel)
			}

			super.init(type: .humidifierDehumidifier, characteristics: characteristics)
		}
	}
}

extension Service {
	open class HumiditySensorBase: Service {

		// Required Characteristics

		public let currentRelativeHumidity = GenericCharacteristic<Float>(
			type: .currentRelativeHumidity,
			permissions: [.read, .events],
			description: "Current Relative Humidity",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<HAP.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [currentRelativeHumidity]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			statusActive = !optionalCharacteristics.contains(.statusActive) ? nil :
				GenericCharacteristic<Bool>(
				type: .statusActive,
				permissions: [.read, .events],
				description: "Status Active")

			if let statusActive = statusActive {
				characteristics.append(statusActive)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			statusLowBattery = !optionalCharacteristics.contains(.statusLowBattery) ? nil :
				GenericCharacteristic<HAP.StatusLowBattery>(
				type: .statusLowBattery,
				permissions: [.read, .events],
				description: "Status Low Battery",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusLowBattery = statusLowBattery {
				characteristics.append(statusLowBattery)
			}

			statusTampered = !optionalCharacteristics.contains(.statusTampered) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusTampered,
				permissions: [.read, .events],
				description: "Status Tampered",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusTampered = statusTampered {
				characteristics.append(statusTampered)
			}

			super.init(type: .humiditySensor, characteristics: characteristics)
		}
	}
}

extension Service {
	open class InfoBase: Service {

		// Required Characteristics

		public let identify = GenericCharacteristic<Bool>(
			type: .identify,
			permissions: [.write],
			description: "Identify")

		public let manufacturer = GenericCharacteristic<String>(
			type: .manufacturer,
			permissions: [.read],
			description: "Manufacturer")

		public let model = GenericCharacteristic<String>(
			type: .model,
			permissions: [.read],
			description: "Model")

		public let name = GenericCharacteristic<String>(
			type: .name,
			permissions: [.read],
			description: "Name")

		public let serialNumber = GenericCharacteristic<String>(
			type: .serialNumber,
			permissions: [.read],
			description: "Serial Number")

		// Optional Characteristics

		public let accessoryFlags: GenericCharacteristic<UInt32>?
		public let applicationMatchingIdentifier: GenericCharacteristic<Data>?
		public let firmwareRevision: GenericCharacteristic<String>?
		public let hardwareRevision: GenericCharacteristic<String>?
		public let softwareRevision: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [identify, manufacturer, model, name, serialNumber]

			accessoryFlags = !optionalCharacteristics.contains(.accessoryFlags) ? nil :
				GenericCharacteristic<UInt32>(
				type: .accessoryFlags,
				permissions: [.read, .events],
				description: "Accessory Flags")

			if let accessoryFlags = accessoryFlags {
				characteristics.append(accessoryFlags)
			}

			applicationMatchingIdentifier = !optionalCharacteristics.contains(.applicationMatchingIdentifier) ? nil :
				GenericCharacteristic<Data>(
				type: .applicationMatchingIdentifier,
				permissions: [.read],
				description: "Application Matching Identifier")

			if let applicationMatchingIdentifier = applicationMatchingIdentifier {
				characteristics.append(applicationMatchingIdentifier)
			}

			firmwareRevision = !optionalCharacteristics.contains(.firmwareRevision) ? nil :
				GenericCharacteristic<String>(
				type: .firmwareRevision,
				permissions: [.read],
				description: "Firmware Revision")

			if let firmwareRevision = firmwareRevision {
				characteristics.append(firmwareRevision)
			}

			hardwareRevision = !optionalCharacteristics.contains(.hardwareRevision) ? nil :
				GenericCharacteristic<String>(
				type: .hardwareRevision,
				permissions: [.read],
				description: "Hardware Revision")

			if let hardwareRevision = hardwareRevision {
				characteristics.append(hardwareRevision)
			}

			softwareRevision = !optionalCharacteristics.contains(.softwareRevision) ? nil :
				GenericCharacteristic<String>(
				type: .softwareRevision,
				permissions: [.read],
				description: "Software Revision")

			if let softwareRevision = softwareRevision {
				characteristics.append(softwareRevision)
			}

			super.init(type: .info, characteristics: characteristics)
		}
	}
}

extension Service {
	open class InputSourceBase: Service {

		// Required Characteristics

		public let configuredName = GenericCharacteristic<String>(
			type: .configuredName,
			permissions: [.read, .events],
			description: "Configured Name")

		public let inputSourceType = GenericCharacteristic<HAP.InputSourceType>(
			type: .inputSourceType,
			permissions: [.read, .events],
			description: "Input Source Type",
			maxValue: 10,
			minValue: 0,
			minStep: 1)

		public let isConfigured = GenericCharacteristic<HAP.IsConfigured>(
			type: .isConfigured,
			permissions: [.read, .events],
			description: "Is Configured",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		public let name = GenericCharacteristic<String>(
			type: .name,
			permissions: [.read],
			description: "Name")

		public let currentVisibilityState = GenericCharacteristic<HAP.CurrentVisibilityState>(
			type: .currentVisibilityState,
			permissions: [.read, .events],
			description: "Current Visibility State",
			maxValue: 3,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let identifier: GenericCharacteristic<UInt32>?
		public let inputDeviceType: GenericCharacteristic<HAP.InputDeviceType>?
		public let targetVisibilityState: GenericCharacteristic<HAP.TargetVisibilityState>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [configuredName, inputSourceType, isConfigured, name, currentVisibilityState]

			identifier = !optionalCharacteristics.contains(.identifier) ? nil :
				GenericCharacteristic<UInt32>(
				type: .identifier,
				permissions: [.read],
				description: "Identifier",
				minValue: 0)

			if let identifier = identifier {
				characteristics.append(identifier)
			}

			inputDeviceType = !optionalCharacteristics.contains(.inputDeviceType) ? nil :
				GenericCharacteristic<HAP.InputDeviceType>(
				type: .inputDeviceType,
				permissions: [.read, .events],
				description: "Input Device Type",
				maxValue: 5,
				minValue: 0,
				minStep: 1)

			if let inputDeviceType = inputDeviceType {
				characteristics.append(inputDeviceType)
			}

			targetVisibilityState = !optionalCharacteristics.contains(.targetVisibilityState) ? nil :
				GenericCharacteristic<HAP.TargetVisibilityState>(
				type: .targetVisibilityState,
				description: "Target Visibility State",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let targetVisibilityState = targetVisibilityState {
				characteristics.append(targetVisibilityState)
			}

			super.init(type: .inputSource, characteristics: characteristics)
		}
	}
}

extension Service {
	open class IrrigationSystemBase: Service {

		// Required Characteristics

		public let active = GenericCharacteristic<HAP.Active>(
			type: .active,
			description: "Active",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		public let programMode = GenericCharacteristic<UInt8>(
			type: .programMode,
			permissions: [.read, .events],
			description: "Program Mode",
			maxValue: 2,
			minValue: 0,
			minStep: 1)

		public let inUse = GenericCharacteristic<UInt8>(
			type: .inUse,
			permissions: [.read, .events],
			description: "In Use",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let remainingDuration: GenericCharacteristic<UInt32>?
		public let name: GenericCharacteristic<String>?
		public let statusFault: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [active, programMode, inUse]

			remainingDuration = !optionalCharacteristics.contains(.remainingDuration) ? nil :
				GenericCharacteristic<UInt32>(
				type: .remainingDuration,
				permissions: [.read, .events],
				description: "Remaining Duration",
				unit: .seconds,
				maxValue: 3600,
				minValue: 0,
				minStep: 1)

			if let remainingDuration = remainingDuration {
				characteristics.append(remainingDuration)
			}

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			super.init(type: .irrigationSystem, characteristics: characteristics)
		}
	}
}

extension Service {
	open class LabelBase: Service {

		// Required Characteristics

		public let labelNamespace = GenericCharacteristic<UInt8>(
			type: .labelNamespace,
			permissions: [.read],
			description: "Label Namespace",
			maxValue: 4,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics


		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [labelNamespace]

			super.init(type: .label, characteristics: characteristics)
		}
	}
}

extension Service {
	open class LeakSensorBase: Service {

		// Required Characteristics

		public let leakDetected = GenericCharacteristic<HAP.LeakDetected>(
			type: .leakDetected,
			permissions: [.read, .events],
			description: "Leak Detected",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<HAP.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [leakDetected]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			statusActive = !optionalCharacteristics.contains(.statusActive) ? nil :
				GenericCharacteristic<Bool>(
				type: .statusActive,
				permissions: [.read, .events],
				description: "Status Active")

			if let statusActive = statusActive {
				characteristics.append(statusActive)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			statusLowBattery = !optionalCharacteristics.contains(.statusLowBattery) ? nil :
				GenericCharacteristic<HAP.StatusLowBattery>(
				type: .statusLowBattery,
				permissions: [.read, .events],
				description: "Status Low Battery",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusLowBattery = statusLowBattery {
				characteristics.append(statusLowBattery)
			}

			statusTampered = !optionalCharacteristics.contains(.statusTampered) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusTampered,
				permissions: [.read, .events],
				description: "Status Tampered",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusTampered = statusTampered {
				characteristics.append(statusTampered)
			}

			super.init(type: .leakSensor, characteristics: characteristics)
		}
	}
}

extension Service {
	open class LightSensorBase: Service {

		// Required Characteristics

		public let currentLightLevel = GenericCharacteristic<Float>(
			type: .currentLightLevel,
			permissions: [.read, .events],
			description: "Current Light Level",
			unit: .lux,
			maxValue: 100000,
			minValue: 0.0001)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<HAP.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [currentLightLevel]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			statusActive = !optionalCharacteristics.contains(.statusActive) ? nil :
				GenericCharacteristic<Bool>(
				type: .statusActive,
				permissions: [.read, .events],
				description: "Status Active")

			if let statusActive = statusActive {
				characteristics.append(statusActive)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			statusLowBattery = !optionalCharacteristics.contains(.statusLowBattery) ? nil :
				GenericCharacteristic<HAP.StatusLowBattery>(
				type: .statusLowBattery,
				permissions: [.read, .events],
				description: "Status Low Battery",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusLowBattery = statusLowBattery {
				characteristics.append(statusLowBattery)
			}

			statusTampered = !optionalCharacteristics.contains(.statusTampered) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusTampered,
				permissions: [.read, .events],
				description: "Status Tampered",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusTampered = statusTampered {
				characteristics.append(statusTampered)
			}

			super.init(type: .lightSensor, characteristics: characteristics)
		}
	}
}

extension Service {
	open class LightbulbBase: Service {

		// Required Characteristics

		public let powerState = GenericCharacteristic<Bool>(
			type: .powerState,
			description: "Power State")

		// Optional Characteristics

		public let brightness: GenericCharacteristic<Int>?
		public let colorTemperature: GenericCharacteristic<Int>?
		public let hue: GenericCharacteristic<Float>?
		public let name: GenericCharacteristic<String>?
		public let saturation: GenericCharacteristic<Float>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [powerState]

			brightness = !optionalCharacteristics.contains(.brightness) ? nil :
				GenericCharacteristic<Int>(
				type: .brightness,
				description: "Brightness",
				unit: .percentage,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let brightness = brightness {
				characteristics.append(brightness)
			}

			colorTemperature = !optionalCharacteristics.contains(.colorTemperature) ? nil :
				GenericCharacteristic<Int>(
				type: .colorTemperature,
				description: "Color Temperature",
				maxValue: 500,
				minValue: 140,
				minStep: 1)

			if let colorTemperature = colorTemperature {
				characteristics.append(colorTemperature)
			}

			hue = !optionalCharacteristics.contains(.hue) ? nil :
				GenericCharacteristic<Float>(
				type: .hue,
				description: "Hue",
				unit: .arcdegrees,
				maxValue: 360,
				minValue: 0,
				minStep: 1)

			if let hue = hue {
				characteristics.append(hue)
			}

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			saturation = !optionalCharacteristics.contains(.saturation) ? nil :
				GenericCharacteristic<Float>(
				type: .saturation,
				description: "Saturation",
				unit: .percentage,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let saturation = saturation {
				characteristics.append(saturation)
			}

			super.init(type: .lightbulb, characteristics: characteristics)
		}
	}
}

extension Service {
	open class LockManagementBase: Service {

		// Required Characteristics

		public let lockControlPoint = GenericCharacteristic<Data>(
			type: .lockControlPoint,
			permissions: [.write],
			description: "Lock Control Point")

		public let version = GenericCharacteristic<String>(
			type: .version,
			permissions: [.read, .events],
			description: "Version")

		// Optional Characteristics

		public let administratorOnlyAccess: GenericCharacteristic<Bool>?
		public let audioFeedback: GenericCharacteristic<Bool>?
		public let currentDoorState: GenericCharacteristic<HAP.CurrentDoorState>?
		public let lockManagementAutoSecurityTimeout: GenericCharacteristic<UInt32>?
		public let lockLastKnownAction: GenericCharacteristic<UInt8>?
		public let logs: GenericCharacteristic<Data>?
		public let motionDetected: GenericCharacteristic<Bool>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [lockControlPoint, version]

			administratorOnlyAccess = !optionalCharacteristics.contains(.administratorOnlyAccess) ? nil :
				GenericCharacteristic<Bool>(
				type: .administratorOnlyAccess,
				description: "Administrator Only Access")

			if let administratorOnlyAccess = administratorOnlyAccess {
				characteristics.append(administratorOnlyAccess)
			}

			audioFeedback = !optionalCharacteristics.contains(.audioFeedback) ? nil :
				GenericCharacteristic<Bool>(
				type: .audioFeedback,
				description: "Audio Feedback")

			if let audioFeedback = audioFeedback {
				characteristics.append(audioFeedback)
			}

			currentDoorState = !optionalCharacteristics.contains(.currentDoorState) ? nil :
				GenericCharacteristic<HAP.CurrentDoorState>(
				type: .currentDoorState,
				permissions: [.read, .events],
				description: "Current Door State",
				maxValue: 4,
				minValue: 0,
				minStep: 1)

			if let currentDoorState = currentDoorState {
				characteristics.append(currentDoorState)
			}

			lockManagementAutoSecurityTimeout = !optionalCharacteristics.contains(.lockManagementAutoSecurityTimeout) ? nil :
				GenericCharacteristic<UInt32>(
				type: .lockManagementAutoSecurityTimeout,
				description: "Lock Management Auto Security Timeout",
				unit: .seconds)

			if let lockManagementAutoSecurityTimeout = lockManagementAutoSecurityTimeout {
				characteristics.append(lockManagementAutoSecurityTimeout)
			}

			lockLastKnownAction = !optionalCharacteristics.contains(.lockLastKnownAction) ? nil :
				GenericCharacteristic<UInt8>(
				type: .lockLastKnownAction,
				permissions: [.read, .events],
				description: "Lock Last Known Action",
				maxValue: 8,
				minValue: 0,
				minStep: 1)

			if let lockLastKnownAction = lockLastKnownAction {
				characteristics.append(lockLastKnownAction)
			}

			logs = !optionalCharacteristics.contains(.logs) ? nil :
				GenericCharacteristic<Data>(
				type: .logs,
				permissions: [.read, .events],
				description: "Logs")

			if let logs = logs {
				characteristics.append(logs)
			}

			motionDetected = !optionalCharacteristics.contains(.motionDetected) ? nil :
				GenericCharacteristic<Bool>(
				type: .motionDetected,
				permissions: [.read, .events],
				description: "Motion Detected")

			if let motionDetected = motionDetected {
				characteristics.append(motionDetected)
			}

			super.init(type: .lockManagement, characteristics: characteristics)
		}
	}
}

extension Service {
	open class LockMechanismBase: Service {

		// Required Characteristics

		public let lockCurrentState = GenericCharacteristic<HAP.LockCurrentState>(
			type: .lockCurrentState,
			permissions: [.read, .events],
			description: "Lock Current State",
			maxValue: 3,
			minValue: 0,
			minStep: 1)

		public let lockTargetState = GenericCharacteristic<HAP.LockTargetState>(
			type: .lockTargetState,
			description: "Lock Target State",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [lockCurrentState, lockTargetState]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			super.init(type: .lockMechanism, characteristics: characteristics)
		}
	}
}

extension Service {
	open class MicrophoneBase: Service {

		// Required Characteristics

		public let mute = GenericCharacteristic<Bool>(
			type: .mute,
			description: "Mute")

		// Optional Characteristics

		public let volume: GenericCharacteristic<Int>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [mute]

			volume = !optionalCharacteristics.contains(.volume) ? nil :
				GenericCharacteristic<Int>(
				type: .volume,
				description: "Volume",
				unit: .percentage,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let volume = volume {
				characteristics.append(volume)
			}

			super.init(type: .microphone, characteristics: characteristics)
		}
	}
}

extension Service {
	open class MotionSensorBase: Service {

		// Required Characteristics

		public let motionDetected = GenericCharacteristic<Bool>(
			type: .motionDetected,
			permissions: [.read, .events],
			description: "Motion Detected")

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<HAP.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [motionDetected]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			statusActive = !optionalCharacteristics.contains(.statusActive) ? nil :
				GenericCharacteristic<Bool>(
				type: .statusActive,
				permissions: [.read, .events],
				description: "Status Active")

			if let statusActive = statusActive {
				characteristics.append(statusActive)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			statusLowBattery = !optionalCharacteristics.contains(.statusLowBattery) ? nil :
				GenericCharacteristic<HAP.StatusLowBattery>(
				type: .statusLowBattery,
				permissions: [.read, .events],
				description: "Status Low Battery",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusLowBattery = statusLowBattery {
				characteristics.append(statusLowBattery)
			}

			statusTampered = !optionalCharacteristics.contains(.statusTampered) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusTampered,
				permissions: [.read, .events],
				description: "Status Tampered",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusTampered = statusTampered {
				characteristics.append(statusTampered)
			}

			super.init(type: .motionSensor, characteristics: characteristics)
		}
	}
}

extension Service {
	open class OccupancySensorBase: Service {

		// Required Characteristics

		public let occupancyDetected = GenericCharacteristic<HAP.OccupancyDetected>(
			type: .occupancyDetected,
			permissions: [.read, .events],
			description: "Occupancy Detected",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<HAP.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [occupancyDetected]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			statusActive = !optionalCharacteristics.contains(.statusActive) ? nil :
				GenericCharacteristic<Bool>(
				type: .statusActive,
				permissions: [.read, .events],
				description: "Status Active")

			if let statusActive = statusActive {
				characteristics.append(statusActive)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			statusLowBattery = !optionalCharacteristics.contains(.statusLowBattery) ? nil :
				GenericCharacteristic<HAP.StatusLowBattery>(
				type: .statusLowBattery,
				permissions: [.read, .events],
				description: "Status Low Battery",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusLowBattery = statusLowBattery {
				characteristics.append(statusLowBattery)
			}

			statusTampered = !optionalCharacteristics.contains(.statusTampered) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusTampered,
				permissions: [.read, .events],
				description: "Status Tampered",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusTampered = statusTampered {
				characteristics.append(statusTampered)
			}

			super.init(type: .occupancySensor, characteristics: characteristics)
		}
	}
}

extension Service {
	open class OutletBase: Service {

		// Required Characteristics

		public let powerState = GenericCharacteristic<Bool>(
			type: .powerState,
			description: "Power State")

		public let outletInUse = GenericCharacteristic<Bool>(
			type: .outletInUse,
			permissions: [.read, .events],
			description: "Outlet In Use")

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [powerState, outletInUse]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			super.init(type: .outlet, characteristics: characteristics)
		}
	}
}

extension Service {
	open class SecuritySystemBase: Service {

		// Required Characteristics

		public let securitySystemCurrentState = GenericCharacteristic<HAP.SecuritySystemCurrentState>(
			type: .securitySystemCurrentState,
			permissions: [.read, .events],
			description: "Security System Current State",
			maxValue: 4,
			minValue: 0,
			minStep: 1)

		public let securitySystemTargetState = GenericCharacteristic<HAP.SecuritySystemTargetState>(
			type: .securitySystemTargetState,
			description: "Security System Target State",
			maxValue: 3,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let securitySystemAlarmType: GenericCharacteristic<UInt8>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [securitySystemCurrentState, securitySystemTargetState]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			securitySystemAlarmType = !optionalCharacteristics.contains(.securitySystemAlarmType) ? nil :
				GenericCharacteristic<UInt8>(
				type: .securitySystemAlarmType,
				permissions: [.read, .events],
				description: "Security System Alarm Type",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let securitySystemAlarmType = securitySystemAlarmType {
				characteristics.append(securitySystemAlarmType)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			statusTampered = !optionalCharacteristics.contains(.statusTampered) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusTampered,
				permissions: [.read, .events],
				description: "Status Tampered",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusTampered = statusTampered {
				characteristics.append(statusTampered)
			}

			super.init(type: .securitySystem, characteristics: characteristics)
		}
	}
}

extension Service {
	open class SlatsBase: Service {

		// Required Characteristics

		public let currentSlatState = GenericCharacteristic<HAP.CurrentSlatState>(
			type: .currentSlatState,
			permissions: [.read, .events],
			description: "Current Slat State",
			maxValue: 3,
			minValue: 0,
			minStep: 1)

		public let slatType = GenericCharacteristic<UInt8>(
			type: .slatType,
			permissions: [.read],
			description: "Slat Type",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let swingMode: GenericCharacteristic<UInt8>?
		public let currentTiltAngle: GenericCharacteristic<Int>?
		public let targetTiltAngle: GenericCharacteristic<Int>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [currentSlatState, slatType]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			swingMode = !optionalCharacteristics.contains(.swingMode) ? nil :
				GenericCharacteristic<UInt8>(
				type: .swingMode,
				description: "Swing Mode",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let swingMode = swingMode {
				characteristics.append(swingMode)
			}

			currentTiltAngle = !optionalCharacteristics.contains(.currentTiltAngle) ? nil :
				GenericCharacteristic<Int>(
				type: .currentTiltAngle,
				permissions: [.read, .events],
				description: "Current Tilt Angle",
				unit: .arcdegrees,
				maxValue: 90,
				minValue: -90,
				minStep: 1)

			if let currentTiltAngle = currentTiltAngle {
				characteristics.append(currentTiltAngle)
			}

			targetTiltAngle = !optionalCharacteristics.contains(.targetTiltAngle) ? nil :
				GenericCharacteristic<Int>(
				type: .targetTiltAngle,
				description: "Target Tilt Angle",
				unit: .arcdegrees,
				maxValue: 90,
				minValue: -90,
				minStep: 1)

			if let targetTiltAngle = targetTiltAngle {
				characteristics.append(targetTiltAngle)
			}

			super.init(type: .slats, characteristics: characteristics)
		}
	}
}

extension Service {
	open class SmokeSensorBase: Service {

		// Required Characteristics

		public let smokeDetected = GenericCharacteristic<HAP.SmokeDetected>(
			type: .smokeDetected,
			permissions: [.read, .events],
			description: "Smoke Detected",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<HAP.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [smokeDetected]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			statusActive = !optionalCharacteristics.contains(.statusActive) ? nil :
				GenericCharacteristic<Bool>(
				type: .statusActive,
				permissions: [.read, .events],
				description: "Status Active")

			if let statusActive = statusActive {
				characteristics.append(statusActive)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			statusLowBattery = !optionalCharacteristics.contains(.statusLowBattery) ? nil :
				GenericCharacteristic<HAP.StatusLowBattery>(
				type: .statusLowBattery,
				permissions: [.read, .events],
				description: "Status Low Battery",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusLowBattery = statusLowBattery {
				characteristics.append(statusLowBattery)
			}

			statusTampered = !optionalCharacteristics.contains(.statusTampered) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusTampered,
				permissions: [.read, .events],
				description: "Status Tampered",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusTampered = statusTampered {
				characteristics.append(statusTampered)
			}

			super.init(type: .smokeSensor, characteristics: characteristics)
		}
	}
}

extension Service {
	open class SpeakerBase: Service {

		// Required Characteristics

		public let mute = GenericCharacteristic<Bool>(
			type: .mute,
			description: "Mute")

		// Optional Characteristics

		public let active: GenericCharacteristic<HAP.Active>?
		public let volume: GenericCharacteristic<Int>?
		public let volumeControlType: GenericCharacteristic<HAP.VolumeControlType>?
		public let volumeSelector: GenericCharacteristic<HAP.VolumeSelector>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [mute]

			active = !optionalCharacteristics.contains(.active) ? nil :
				GenericCharacteristic<HAP.Active>(
				type: .active,
				description: "Active",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let active = active {
				characteristics.append(active)
			}

			volume = !optionalCharacteristics.contains(.volume) ? nil :
				GenericCharacteristic<Int>(
				type: .volume,
				description: "Volume",
				unit: .percentage,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let volume = volume {
				characteristics.append(volume)
			}

			volumeControlType = !optionalCharacteristics.contains(.volumeControlType) ? nil :
				GenericCharacteristic<HAP.VolumeControlType>(
				type: .volumeControlType,
				permissions: [.read, .events],
				description: "Volume Control Type",
				maxValue: 3,
				minValue: 0,
				minStep: 1)

			if let volumeControlType = volumeControlType {
				characteristics.append(volumeControlType)
			}

			volumeSelector = !optionalCharacteristics.contains(.volumeSelector) ? nil :
				GenericCharacteristic<HAP.VolumeSelector>(
				type: .volumeSelector,
				permissions: [.write],
				description: "Volume Selector",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let volumeSelector = volumeSelector {
				characteristics.append(volumeSelector)
			}

			super.init(type: .speaker, characteristics: characteristics)
		}
	}
}

extension Service {
	open class StatefulProgrammableSwitchBase: Service {

		// Required Characteristics

		public let programmableSwitchEvent = GenericCharacteristic<UInt8>(
			type: .programmableSwitchEvent,
			permissions: [.read, .events],
			description: "Programmable Switch Event",
			maxValue: 2,
			minValue: 0,
			minStep: 1)

		public let programmableSwitchOutputState = GenericCharacteristic<UInt8>(
			type: .programmableSwitchOutputState,
			description: "Programmable Switch Output State",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [programmableSwitchEvent, programmableSwitchOutputState]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			super.init(type: .statefulProgrammableSwitch, characteristics: characteristics)
		}
	}
}

extension Service {
	open class StatelessProgrammableSwitchBase: Service {

		// Required Characteristics

		public let programmableSwitchEvent = GenericCharacteristic<UInt8>(
			type: .programmableSwitchEvent,
			permissions: [.read, .events],
			description: "Programmable Switch Event",
			maxValue: 2,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let labelIndex: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [programmableSwitchEvent]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			labelIndex = !optionalCharacteristics.contains(.labelIndex) ? nil :
				GenericCharacteristic<UInt8>(
				type: .labelIndex,
				permissions: [.read],
				description: "Label Index",
				maxValue: 255,
				minValue: 1,
				minStep: 1)

			if let labelIndex = labelIndex {
				characteristics.append(labelIndex)
			}

			super.init(type: .statelessProgrammableSwitch, characteristics: characteristics)
		}
	}
}

extension Service {
	open class SwitchBase: Service {

		// Required Characteristics

		public let powerState = GenericCharacteristic<Bool>(
			type: .powerState,
			description: "Power State")

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [powerState]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			super.init(type: .`switch`, characteristics: characteristics)
		}
	}
}

extension Service {
	open class TelevisionBase: Service {

		// Required Characteristics

		public let active = GenericCharacteristic<HAP.Active>(
			type: .active,
			description: "Active",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		public let activeIdentifier = GenericCharacteristic<UInt32>(
			type: .activeIdentifier,
			description: "Active Identifier",
			minValue: 0)

		public let configuredName = GenericCharacteristic<String>(
			type: .configuredName,
			permissions: [.read, .events],
			description: "Configured Name")

		public let sleepDiscoveryMode = GenericCharacteristic<HAP.SleepDiscoveryMode>(
			type: .sleepDiscoveryMode,
			permissions: [.read, .events],
			description: "Sleep Discovery Mode",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let brightness: GenericCharacteristic<Int>?
		public let closedCaptions: GenericCharacteristic<HAP.ClosedCaptions>?
		public let displayOrder: GenericCharacteristic<Data>?
		public let currentMediaState: GenericCharacteristic<UInt8>?
		public let targetMediaState: GenericCharacteristic<HAP.TargetMediaState>?
		public let pictureMode: GenericCharacteristic<HAP.PictureMode>?
		public let powerModeSelection: GenericCharacteristic<HAP.PowerModeSelection>?
		public let remoteKey: GenericCharacteristic<HAP.RemoteKey>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [active, activeIdentifier, configuredName, sleepDiscoveryMode]

			brightness = !optionalCharacteristics.contains(.brightness) ? nil :
				GenericCharacteristic<Int>(
				type: .brightness,
				description: "Brightness",
				unit: .percentage,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let brightness = brightness {
				characteristics.append(brightness)
			}

			closedCaptions = !optionalCharacteristics.contains(.closedCaptions) ? nil :
				GenericCharacteristic<HAP.ClosedCaptions>(
				type: .closedCaptions,
				description: "Closed Captions",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let closedCaptions = closedCaptions {
				characteristics.append(closedCaptions)
			}

			displayOrder = !optionalCharacteristics.contains(.displayOrder) ? nil :
				GenericCharacteristic<Data>(
				type: .displayOrder,
				permissions: [.read, .events],
				description: "Display Order")

			if let displayOrder = displayOrder {
				characteristics.append(displayOrder)
			}

			currentMediaState = !optionalCharacteristics.contains(.currentMediaState) ? nil :
				GenericCharacteristic<UInt8>(
				type: .currentMediaState,
				permissions: [.read, .events],
				description: "Current Media State",
				maxValue: 3,
				minValue: 0,
				minStep: 1)

			if let currentMediaState = currentMediaState {
				characteristics.append(currentMediaState)
			}

			targetMediaState = !optionalCharacteristics.contains(.targetMediaState) ? nil :
				GenericCharacteristic<HAP.TargetMediaState>(
				type: .targetMediaState,
				description: "Target Media State",
				maxValue: 2,
				minValue: 0,
				minStep: 1)

			if let targetMediaState = targetMediaState {
				characteristics.append(targetMediaState)
			}

			pictureMode = !optionalCharacteristics.contains(.pictureMode) ? nil :
				GenericCharacteristic<HAP.PictureMode>(
				type: .pictureMode,
				description: "Picture Mode",
				maxValue: 13,
				minValue: 0,
				minStep: 1)

			if let pictureMode = pictureMode {
				characteristics.append(pictureMode)
			}

			powerModeSelection = !optionalCharacteristics.contains(.powerModeSelection) ? nil :
				GenericCharacteristic<HAP.PowerModeSelection>(
				type: .powerModeSelection,
				permissions: [.write],
				description: "Power Mode Selection",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let powerModeSelection = powerModeSelection {
				characteristics.append(powerModeSelection)
			}

			remoteKey = !optionalCharacteristics.contains(.remoteKey) ? nil :
				GenericCharacteristic<HAP.RemoteKey>(
				type: .remoteKey,
				permissions: [.write],
				description: "Remote Key",
				maxValue: 16,
				minValue: 0,
				minStep: 1)

			if let remoteKey = remoteKey {
				characteristics.append(remoteKey)
			}

			super.init(type: .television, characteristics: characteristics)
		}
	}
}

extension Service {
	open class TemperatureSensorBase: Service {

		// Required Characteristics

		public let currentTemperature = GenericCharacteristic<Float>(
			type: .currentTemperature,
			permissions: [.read, .events],
			description: "Current Temperature",
			unit: .celsius,
			maxValue: 100,
			minValue: 0,
			minStep: 0.1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let statusActive: GenericCharacteristic<Bool>?
		public let statusFault: GenericCharacteristic<UInt8>?
		public let statusLowBattery: GenericCharacteristic<HAP.StatusLowBattery>?
		public let statusTampered: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [currentTemperature]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			statusActive = !optionalCharacteristics.contains(.statusActive) ? nil :
				GenericCharacteristic<Bool>(
				type: .statusActive,
				permissions: [.read, .events],
				description: "Status Active")

			if let statusActive = statusActive {
				characteristics.append(statusActive)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			statusLowBattery = !optionalCharacteristics.contains(.statusLowBattery) ? nil :
				GenericCharacteristic<HAP.StatusLowBattery>(
				type: .statusLowBattery,
				permissions: [.read, .events],
				description: "Status Low Battery",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusLowBattery = statusLowBattery {
				characteristics.append(statusLowBattery)
			}

			statusTampered = !optionalCharacteristics.contains(.statusTampered) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusTampered,
				permissions: [.read, .events],
				description: "Status Tampered",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusTampered = statusTampered {
				characteristics.append(statusTampered)
			}

			super.init(type: .temperatureSensor, characteristics: characteristics)
		}
	}
}

extension Service {
	open class ThermostatBase: Service {

		// Required Characteristics

		public let currentHeatingCoolingState = GenericCharacteristic<HAP.CurrentHeatingCoolingState>(
			type: .currentHeatingCoolingState,
			permissions: [.read, .events],
			description: "Current Heating Cooling State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)

		public let targetHeatingCoolingState = GenericCharacteristic<HAP.TargetHeatingCoolingState>(
			type: .targetHeatingCoolingState,
			description: "Target Heating Cooling State",
			maxValue: 3,
			minValue: 0,
			minStep: 1)

		public let currentTemperature = GenericCharacteristic<Float>(
			type: .currentTemperature,
			permissions: [.read, .events],
			description: "Current Temperature",
			unit: .celsius,
			maxValue: 100,
			minValue: 0,
			minStep: 0.1)

		public let targetTemperature = GenericCharacteristic<Float>(
			type: .targetTemperature,
			description: "Target Temperature",
			unit: .celsius,
			maxValue: 38,
			minValue: 10,
			minStep: 0.1)

		public let temperatureDisplayUnits = GenericCharacteristic<HAP.TemperatureDisplayUnits>(
			type: .temperatureDisplayUnits,
			description: "Temperature Display Units",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let currentRelativeHumidity: GenericCharacteristic<Float>?
		public let targetRelativeHumidity: GenericCharacteristic<Float>?
		public let coolingThresholdTemperature: GenericCharacteristic<Float>?
		public let heatingThresholdTemperature: GenericCharacteristic<Float>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [currentHeatingCoolingState, targetHeatingCoolingState, currentTemperature, targetTemperature, temperatureDisplayUnits]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			currentRelativeHumidity = !optionalCharacteristics.contains(.currentRelativeHumidity) ? nil :
				GenericCharacteristic<Float>(
				type: .currentRelativeHumidity,
				permissions: [.read, .events],
				description: "Current Relative Humidity",
				unit: .percentage,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let currentRelativeHumidity = currentRelativeHumidity {
				characteristics.append(currentRelativeHumidity)
			}

			targetRelativeHumidity = !optionalCharacteristics.contains(.targetRelativeHumidity) ? nil :
				GenericCharacteristic<Float>(
				type: .targetRelativeHumidity,
				description: "Target Relative Humidity",
				unit: .percentage,
				maxValue: 100,
				minValue: 0,
				minStep: 1)

			if let targetRelativeHumidity = targetRelativeHumidity {
				characteristics.append(targetRelativeHumidity)
			}

			coolingThresholdTemperature = !optionalCharacteristics.contains(.coolingThresholdTemperature) ? nil :
				GenericCharacteristic<Float>(
				type: .coolingThresholdTemperature,
				description: "Cooling Threshold Temperature",
				unit: .celsius,
				maxValue: 35,
				minValue: 10,
				minStep: 0.1)

			if let coolingThresholdTemperature = coolingThresholdTemperature {
				characteristics.append(coolingThresholdTemperature)
			}

			heatingThresholdTemperature = !optionalCharacteristics.contains(.heatingThresholdTemperature) ? nil :
				GenericCharacteristic<Float>(
				type: .heatingThresholdTemperature,
				description: "Heating Threshold Temperature",
				unit: .celsius,
				maxValue: 25,
				minValue: 0,
				minStep: 0.1)

			if let heatingThresholdTemperature = heatingThresholdTemperature {
				characteristics.append(heatingThresholdTemperature)
			}

			super.init(type: .thermostat, characteristics: characteristics)
		}
	}
}

extension Service {
	open class ValveBase: Service {

		// Required Characteristics

		public let active = GenericCharacteristic<HAP.Active>(
			type: .active,
			description: "Active",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		public let inUse = GenericCharacteristic<UInt8>(
			type: .inUse,
			permissions: [.read, .events],
			description: "In Use",
			maxValue: 1,
			minValue: 0,
			minStep: 1)

		public let valveType = GenericCharacteristic<UInt8>(
			type: .valveType,
			permissions: [.read, .events],
			description: "Valve Type",
			maxValue: 3,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let isConfigured: GenericCharacteristic<HAP.IsConfigured>?
		public let name: GenericCharacteristic<String>?
		public let remainingDuration: GenericCharacteristic<UInt32>?
		public let labelIndex: GenericCharacteristic<UInt8>?
		public let setDuration: GenericCharacteristic<UInt32>?
		public let statusFault: GenericCharacteristic<UInt8>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [active, inUse, valveType]

			isConfigured = !optionalCharacteristics.contains(.isConfigured) ? nil :
				GenericCharacteristic<HAP.IsConfigured>(
				type: .isConfigured,
				permissions: [.read, .events],
				description: "Is Configured",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let isConfigured = isConfigured {
				characteristics.append(isConfigured)
			}

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			remainingDuration = !optionalCharacteristics.contains(.remainingDuration) ? nil :
				GenericCharacteristic<UInt32>(
				type: .remainingDuration,
				permissions: [.read, .events],
				description: "Remaining Duration",
				unit: .seconds,
				maxValue: 3600,
				minValue: 0,
				minStep: 1)

			if let remainingDuration = remainingDuration {
				characteristics.append(remainingDuration)
			}

			labelIndex = !optionalCharacteristics.contains(.labelIndex) ? nil :
				GenericCharacteristic<UInt8>(
				type: .labelIndex,
				permissions: [.read],
				description: "Label Index",
				maxValue: 255,
				minValue: 1,
				minStep: 1)

			if let labelIndex = labelIndex {
				characteristics.append(labelIndex)
			}

			setDuration = !optionalCharacteristics.contains(.setDuration) ? nil :
				GenericCharacteristic<UInt32>(
				type: .setDuration,
				description: "Set Duration",
				unit: .seconds,
				maxValue: 3600,
				minValue: 0,
				minStep: 1)

			if let setDuration = setDuration {
				characteristics.append(setDuration)
			}

			statusFault = !optionalCharacteristics.contains(.statusFault) ? nil :
				GenericCharacteristic<UInt8>(
				type: .statusFault,
				permissions: [.read, .events],
				description: "Status Fault",
				maxValue: 1,
				minValue: 0,
				minStep: 1)

			if let statusFault = statusFault {
				characteristics.append(statusFault)
			}

			super.init(type: .valve, characteristics: characteristics)
		}
	}
}

extension Service {
	open class WindowBase: Service {

		// Required Characteristics

		public let currentPosition = GenericCharacteristic<UInt8>(
			type: .currentPosition,
			permissions: [.read, .events],
			description: "Current Position",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)

		public let positionState = GenericCharacteristic<HAP.PositionState>(
			type: .positionState,
			permissions: [.read, .events],
			description: "Position State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)

		public let targetPosition = GenericCharacteristic<UInt8>(
			type: .targetPosition,
			description: "Target Position",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let name: GenericCharacteristic<String>?
		public let obstructionDetected: GenericCharacteristic<Bool>?
		public let holdPosition: GenericCharacteristic<Bool>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [currentPosition, positionState, targetPosition]

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			obstructionDetected = !optionalCharacteristics.contains(.obstructionDetected) ? nil :
				GenericCharacteristic<Bool>(
				type: .obstructionDetected,
				permissions: [.read, .events],
				description: "Obstruction Detected")

			if let obstructionDetected = obstructionDetected {
				characteristics.append(obstructionDetected)
			}

			holdPosition = !optionalCharacteristics.contains(.holdPosition) ? nil :
				GenericCharacteristic<Bool>(
				type: .holdPosition,
				permissions: [.write],
				description: "Hold Position")

			if let holdPosition = holdPosition {
				characteristics.append(holdPosition)
			}

			super.init(type: .window, characteristics: characteristics)
		}
	}
}

extension Service {
	open class WindowCoveringBase: Service {

		// Required Characteristics

		public let currentPosition = GenericCharacteristic<UInt8>(
			type: .currentPosition,
			permissions: [.read, .events],
			description: "Current Position",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)

		public let positionState = GenericCharacteristic<HAP.PositionState>(
			type: .positionState,
			permissions: [.read, .events],
			description: "Position State",
			maxValue: 2,
			minValue: 0,
			minStep: 1)

		public let targetPosition = GenericCharacteristic<UInt8>(
			type: .targetPosition,
			description: "Target Position",
			unit: .percentage,
			maxValue: 100,
			minValue: 0,
			minStep: 1)

		// Optional Characteristics

		public let currentHorizontalTiltAngle: GenericCharacteristic<Int>?
		public let targetHorizontalTiltAngle: GenericCharacteristic<Int>?
		public let name: GenericCharacteristic<String>?
		public let obstructionDetected: GenericCharacteristic<Bool>?
		public let holdPosition: GenericCharacteristic<Bool>?
		public let currentVerticalTiltAngle: GenericCharacteristic<Int>?
		public let targetVerticalTiltAngle: GenericCharacteristic<Int>?

		public init(optionalCharacteristics: [CharacteristicType] = []) {

			var characteristics: [Characteristic] = [currentPosition, positionState, targetPosition]

			currentHorizontalTiltAngle = !optionalCharacteristics.contains(.currentHorizontalTiltAngle) ? nil :
				GenericCharacteristic<Int>(
				type: .currentHorizontalTiltAngle,
				permissions: [.read, .events],
				description: "Current Horizontal Tilt Angle",
				unit: .arcdegrees,
				maxValue: 90,
				minValue: -90,
				minStep: 1)

			if let currentHorizontalTiltAngle = currentHorizontalTiltAngle {
				characteristics.append(currentHorizontalTiltAngle)
			}

			targetHorizontalTiltAngle = !optionalCharacteristics.contains(.targetHorizontalTiltAngle) ? nil :
				GenericCharacteristic<Int>(
				type: .targetHorizontalTiltAngle,
				description: "Target Horizontal Tilt Angle",
				unit: .arcdegrees,
				maxValue: 90,
				minValue: -90,
				minStep: 1)

			if let targetHorizontalTiltAngle = targetHorizontalTiltAngle {
				characteristics.append(targetHorizontalTiltAngle)
			}

			name = !optionalCharacteristics.contains(.name) ? nil :
				GenericCharacteristic<String>(
				type: .name,
				permissions: [.read],
				description: "Name")

			if let name = name {
				characteristics.append(name)
			}

			obstructionDetected = !optionalCharacteristics.contains(.obstructionDetected) ? nil :
				GenericCharacteristic<Bool>(
				type: .obstructionDetected,
				permissions: [.read, .events],
				description: "Obstruction Detected")

			if let obstructionDetected = obstructionDetected {
				characteristics.append(obstructionDetected)
			}

			holdPosition = !optionalCharacteristics.contains(.holdPosition) ? nil :
				GenericCharacteristic<Bool>(
				type: .holdPosition,
				permissions: [.write],
				description: "Hold Position")

			if let holdPosition = holdPosition {
				characteristics.append(holdPosition)
			}

			currentVerticalTiltAngle = !optionalCharacteristics.contains(.currentVerticalTiltAngle) ? nil :
				GenericCharacteristic<Int>(
				type: .currentVerticalTiltAngle,
				permissions: [.read, .events],
				description: "Current Vertical Tilt Angle",
				unit: .arcdegrees,
				maxValue: 90,
				minValue: -90,
				minStep: 1)

			if let currentVerticalTiltAngle = currentVerticalTiltAngle {
				characteristics.append(currentVerticalTiltAngle)
			}

			targetVerticalTiltAngle = !optionalCharacteristics.contains(.targetVerticalTiltAngle) ? nil :
				GenericCharacteristic<Int>(
				type: .targetVerticalTiltAngle,
				description: "Target Vertical Tilt Angle",
				unit: .arcdegrees,
				maxValue: 90,
				minValue: -90,
				minStep: 1)

			if let targetVerticalTiltAngle = targetVerticalTiltAngle {
				characteristics.append(targetVerticalTiltAngle)
			}

			super.init(type: .windowCovering, characteristics: characteristics)
		}
	}
}
