// swiftlint:disable no_grouping_extension
public extension CharacteristicType {
    static let accessoryFlags = CharacteristicType(0x00A6)
    static let active = CharacteristicType(0x00B0)
    static let activeIdentifier = CharacteristicType(0x00E7)
    static let activityInterval = CharacteristicType(0x023B)
    static let administratorOnlyAccess = CharacteristicType(0x0001)
    static let applicationMatchingIdentifier = CharacteristicType(0x00A4)
    static let assetUpdateReadiness = CharacteristicType(0x0269)
    static let audioFeedback = CharacteristicType(0x0005)
    static let batteryLevel = CharacteristicType(0x0068)
    static let brightness = CharacteristicType(0x0008)
    static let ccaEnergyDetectThreshold = CharacteristicType(0x0246)
    static let ccaSignalDetectThreshold = CharacteristicType(0x0245)
    static let carbonDioxideDetected = CharacteristicType(0x0092)
    static let carbonDioxideLevel = CharacteristicType(0x0093)
    static let carbonDioxidePeakLevel = CharacteristicType(0x0094)
    static let carbonMonoxideDetected = CharacteristicType(0x0069)
    static let carbonMonoxideLevel = CharacteristicType(0x0090)
    static let carbonMonoxidePeakLevel = CharacteristicType(0x0091)
    static let characteristicValueActiveTransitionCount = CharacteristicType(0x024B)
    static let characteristicValueTransitionControl = CharacteristicType(0x0143)
    static let chargingState = CharacteristicType(0x008F)
    static let closedCaptions = CharacteristicType(0x00DD)
    static let colorTemperature = CharacteristicType(0x00CE)
    static let configuredName = CharacteristicType(0x00E3)
    static let contactSensorState = CharacteristicType(0x006A)
    static let coolingThresholdTemperature = CharacteristicType(0x000D)
    static let cryptoHash = CharacteristicType(0x0250)
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
    static let currentTransport = CharacteristicType(0x022B)
    static let currentVerticalTiltAngle = CharacteristicType(0x006E)
    static let currentVisibilityState = CharacteristicType(0x0135)
    static let currentWaterLevel = CharacteristicType(0x00B5)
    static let displayOrder = CharacteristicType(0x0136)
    static let eventRetransmissionMaximum = CharacteristicType(0x023D)
    static let eventTransmissionCounters = CharacteristicType(0x023E)
    static let filterChangeIndication = CharacteristicType(0x00AC)
    static let filterLifeLevel = CharacteristicType(0x00AB)
    static let filterResetChangeIndication = CharacteristicType(0x00AD)
    static let firmwareRevision = CharacteristicType(0x0052)
    static let firmwareUpdateReadiness = CharacteristicType(0x0234)
    static let firmwareUpdateStatus = CharacteristicType(0x0235)
    static let hardwareFinish = CharacteristicType(0x026C)
    static let hardwareRevision = CharacteristicType(0x0053)
    static let heartBeat = CharacteristicType(0x024A)
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
    static let macRetransmissionMaximum = CharacteristicType(0x0247)
    static let macTransmissionCounters = CharacteristicType(0x0248)
    static let manufacturer = CharacteristicType(0x0020)
    static let maximumTransmitPower = CharacteristicType(0x0243)
    static let metricsBufferFullState = CharacteristicType(0x0272)
    static let model = CharacteristicType(0x0021)
    static let motionDetected = CharacteristicType(0x0022)
    static let mute = CharacteristicType(0x011A)
    static let name = CharacteristicType(0x0023)
    static let nitrogenDioxideDensity = CharacteristicType(0x00C4)
    static let obstructionDetected = CharacteristicType(0x0024)
    static let occupancyDetected = CharacteristicType(0x0071)
    static let operatingStateResponse = CharacteristicType(0x0232)
    static let outletInUse = CharacteristicType(0x0026)
    static let ozoneDensity = CharacteristicType(0x00C3)
    static let pm10Density = CharacteristicType(0x00C7)
    static let pm25Density = CharacteristicType(0x00C6)
    static let pictureMode = CharacteristicType(0x00E2)
    static let ping = CharacteristicType(0x023C)
    static let positionState = CharacteristicType(0x0072)
    static let powerModeSelection = CharacteristicType(0x00DF)
    static let powerState = CharacteristicType(0x0025)
    static let productData = CharacteristicType(0x0220)
    static let programMode = CharacteristicType(0x00D1)
    static let programmableSwitchEvent = CharacteristicType(0x0073)
    static let programmableSwitchOutputState = CharacteristicType(0x0074)
    static let receivedSignalStrengthIndication = CharacteristicType(0x023F)
    static let receiverSensitivity = CharacteristicType(0x0244)
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
    static let selectedDiagnosticsModes = CharacteristicType(0x024D)
    static let serialNumber = CharacteristicType(0x0030)
    static let setDuration = CharacteristicType(0x00D3)
    static let setupTransferTransport = CharacteristicType(0x0201)
    static let signalToNoiseRatio = CharacteristicType(0x0241)
    static let slatType = CharacteristicType(0x00C0)
    static let sleepDiscoveryMode = CharacteristicType(0x00E8)
    static let sleepInterval = CharacteristicType(0x023A)
    static let smokeDetected = CharacteristicType(0x0076)
    static let softwareRevision = CharacteristicType(0x0054)
    static let stagedFirmwareVersion = CharacteristicType(0x0249)
    static let statusActive = CharacteristicType(0x0075)
    static let statusFault = CharacteristicType(0x0077)
    static let statusLowBattery = CharacteristicType(0x0079)
    static let statusTampered = CharacteristicType(0x007A)
    static let sulphurDioxideDensity = CharacteristicType(0x00C5)
    static let supportedAssetTypes = CharacteristicType(0x0268)
    static let supportedCharacteristicValueTransitionConfiguration = CharacteristicType(0x0144)
    static let supportedDiagnosticsModes = CharacteristicType(0x024C)
    static let supportedDiagnosticsSnapshot = CharacteristicType(0x0238)
    static let supportedFirmwareUpdateConfiguration = CharacteristicType(0x0233)
    static let supportedMetrics = CharacteristicType(0x0271)
    static let supportedTransferTransportConfiguration = CharacteristicType(0x0202)
    static let swingMode = CharacteristicType(0x00B6)
    static let tapType = CharacteristicType(0x022F)
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
    static let threadControlPoint = CharacteristicType(0x0704)
    static let threadNodeCapabilities = CharacteristicType(0x0702)
    static let threadOpenthreadVersion = CharacteristicType(0x0706)
    static let threadStatus = CharacteristicType(0x0703)
    static let token = CharacteristicType(0x0231)
    static let transmitPower = CharacteristicType(0x0242)
    static let valveType = CharacteristicType(0x00D5)
    static let version = CharacteristicType(0x0037)
    static let volatileOrganicCompoundDensity = CharacteristicType(0x00C8)
    static let volume = CharacteristicType(0x0119)
    static let volumeControlType = CharacteristicType(0x00E9)
    static let volumeSelector = CharacteristicType(0x00EA)
    static let wiFiCapabilities = CharacteristicType(0x022C)
    static let wiFiConfigurationControl = CharacteristicType(0x022D)
}

extension CharacteristicType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .accessoryFlags: return "Accessory Flags"
        case .active: return "Active"
        case .activeIdentifier: return "Active Identifier"
        case .activityInterval: return "Activity Interval"
        case .administratorOnlyAccess: return "Administrator Only Access"
        case .applicationMatchingIdentifier: return "Application Matching Identifier"
        case .assetUpdateReadiness: return "Asset Update Readiness"
        case .audioFeedback: return "Audio Feedback"
        case .batteryLevel: return "Battery Level"
        case .brightness: return "Brightness"
        case .ccaEnergyDetectThreshold: return "CCA Energy Detect Threshold"
        case .ccaSignalDetectThreshold: return "CCA Signal Detect Threshold"
        case .carbonDioxideDetected: return "Carbon dioxide Detected"
        case .carbonDioxideLevel: return "Carbon dioxide Level"
        case .carbonDioxidePeakLevel: return "Carbon dioxide Peak Level"
        case .carbonMonoxideDetected: return "Carbon monoxide Detected"
        case .carbonMonoxideLevel: return "Carbon monoxide Level"
        case .carbonMonoxidePeakLevel: return "Carbon monoxide Peak Level"
        case .characteristicValueActiveTransitionCount: return "Characteristic Value Active Transition Count"
        case .characteristicValueTransitionControl: return "Characteristic Value Transition Control"
        case .chargingState: return "Charging State"
        case .closedCaptions: return "Closed Captions"
        case .colorTemperature: return "Color Temperature"
        case .configuredName: return "Configured Name"
        case .contactSensorState: return "Contact Sensor State"
        case .coolingThresholdTemperature: return "Cooling Threshold Temperature"
        case .cryptoHash: return "Crypto Hash"
        case .currentAirPurifierState: return "Current Air Purifier State"
        case .currentAirQuality: return "Current Air Quality"
        case .currentDoorState: return "Current Door State"
        case .currentFanState: return "Current Fan State"
        case .currentHeaterCoolerState: return "Current Heater-Cooler State"
        case .currentHeatingCoolingState: return "Current Heating Cooling State"
        case .currentHorizontalTiltAngle: return "Current Horizontal Tilt Angle"
        case .currentHumidifierDehumidifierState: return "Current Humidifier-Dehumidifier State"
        case .currentLightLevel: return "Current Light Level"
        case .currentMediaState: return "Current Media State"
        case .currentPosition: return "Current Position"
        case .currentRelativeHumidity: return "Current Relative Humidity"
        case .currentSlatState: return "Current Slat State"
        case .currentTemperature: return "Current Temperature"
        case .currentTiltAngle: return "Current Tilt Angle"
        case .currentTransport: return "Current Transport"
        case .currentVerticalTiltAngle: return "Current Vertical Tilt Angle"
        case .currentVisibilityState: return "Current Visibility State"
        case .currentWaterLevel: return "Current Water Level"
        case .displayOrder: return "Display Order"
        case .eventRetransmissionMaximum: return "Event Retransmission Maximum"
        case .eventTransmissionCounters: return "Event Transmission Counters"
        case .filterChangeIndication: return "Filter Change indication"
        case .filterLifeLevel: return "Filter Life Level"
        case .filterResetChangeIndication: return "Filter Reset Change Indication"
        case .firmwareRevision: return "Firmware Revision"
        case .firmwareUpdateReadiness: return "Firmware Update Readiness"
        case .firmwareUpdateStatus: return "Firmware Update Status"
        case .hardwareFinish: return "Hardware Finish"
        case .hardwareRevision: return "Hardware Revision"
        case .heartBeat: return "Heart Beat"
        case .heatingThresholdTemperature: return "Heating Threshold Temperature"
        case .holdPosition: return "Hold Position"
        case .hue: return "Hue"
        case .identifier: return "Identifier"
        case .identify: return "Identify"
        case .inUse: return "In Use"
        case .inputDeviceType: return "Input Device Type"
        case .inputSourceType: return "Input Source Type"
        case .isConfigured: return "Is Configured"
        case .labelIndex: return "Label Index"
        case .labelNamespace: return "Label Namespace"
        case .leakDetected: return "Leak Detected"
        case .lockControlPoint: return "Lock Control Point"
        case .lockCurrentState: return "Lock Current State"
        case .lockLastKnownAction: return "Lock Last Known Action"
        case .lockManagementAutoSecurityTimeout: return "Lock Management Auto Security Timeout"
        case .lockPhysicalControls: return "Lock Physical Controls"
        case .lockTargetState: return "Lock Target State"
        case .logs: return "Logs"
        case .macRetransmissionMaximum: return "MAC Retransmission Maximum"
        case .macTransmissionCounters: return "MAC Transmission Counters"
        case .manufacturer: return "Manufacturer"
        case .maximumTransmitPower: return "Maximum Transmit Power"
        case .metricsBufferFullState: return "Metrics Buffer Full State"
        case .model: return "Model"
        case .motionDetected: return "Motion Detected"
        case .mute: return "Mute"
        case .name: return "Name"
        case .nitrogenDioxideDensity: return "Nitrogen dioxide Density"
        case .obstructionDetected: return "Obstruction Detected"
        case .occupancyDetected: return "Occupancy Detected"
        case .operatingStateResponse: return "Operating State Response"
        case .outletInUse: return "Outlet In Use"
        case .ozoneDensity: return "Ozone Density"
        case .pm10Density: return "PM10 Density"
        case .pm25Density: return "PM2.5 Density"
        case .pictureMode: return "Picture Mode"
        case .ping: return "Ping"
        case .positionState: return "Position State"
        case .powerModeSelection: return "Power Mode Selection"
        case .powerState: return "Power State"
        case .productData: return "Product Data"
        case .programMode: return "Program Mode"
        case .programmableSwitchEvent: return "Programmable Switch Event"
        case .programmableSwitchOutputState: return "Programmable Switch Output State"
        case .receivedSignalStrengthIndication: return "Received Signal Strength Indication"
        case .receiverSensitivity: return "Receiver Sensitivity"
        case .relativeHumidityDehumidifierThreshold: return "Relative Humidity Dehumidifier Threshold"
        case .relativeHumidityHumidifierThreshold: return "Relative Humidity Humidifier Threshold"
        case .remainingDuration: return "Remaining Duration"
        case .remoteKey: return "Remote Key"
        case .rotationDirection: return "Rotation Direction"
        case .rotationSpeed: return "Rotation Speed"
        case .saturation: return "Saturation"
        case .securitySystemAlarmType: return "Security System Alarm Type"
        case .securitySystemCurrentState: return "Security System Current State"
        case .securitySystemTargetState: return "Security System Target State"
        case .selectedDiagnosticsModes: return "Selected Diagnostics Modes"
        case .serialNumber: return "Serial Number"
        case .setDuration: return "Set Duration"
        case .setupTransferTransport: return "Setup Transfer Transport"
        case .signalToNoiseRatio: return "Signal-to-noise Ratio"
        case .slatType: return "Slat Type"
        case .sleepDiscoveryMode: return "Sleep Discovery Mode"
        case .sleepInterval: return "Sleep Interval"
        case .smokeDetected: return "Smoke Detected"
        case .softwareRevision: return "Software Revision"
        case .stagedFirmwareVersion: return "Staged Firmware Version"
        case .statusActive: return "Status Active"
        case .statusFault: return "Status Fault"
        case .statusLowBattery: return "Status Low Battery"
        case .statusTampered: return "Status Tampered"
        case .sulphurDioxideDensity: return "Sulphur dioxide Density"
        case .supportedAssetTypes: return "Supported Asset Types"
        case .supportedCharacteristicValueTransitionConfiguration: return "Supported Characteristic Value Transition Configuration"
        case .supportedDiagnosticsModes: return "Supported Diagnostics Modes"
        case .supportedDiagnosticsSnapshot: return "Supported Diagnostics Snapshot"
        case .supportedFirmwareUpdateConfiguration: return "Supported Firmware Update Configuration"
        case .supportedMetrics: return "Supported Metrics"
        case .supportedTransferTransportConfiguration: return "Supported Transfer Transport Configuration"
        case .swingMode: return "Swing Mode"
        case .tapType: return "Tap Type"
        case .targetAirPurifierState: return "Target Air Purifier State"
        case .targetDoorState: return "Target Door State"
        case .targetFanState: return "Target Fan State"
        case .targetHeaterCoolerState: return "Target Heater-Cooler State"
        case .targetHeatingCoolingState: return "Target Heating Cooling State"
        case .targetHorizontalTiltAngle: return "Target Horizontal Tilt Angle"
        case .targetHumidifierDehumidifierState: return "Target Humidifier-Dehumidifier State"
        case .targetMediaState: return "Target Media State"
        case .targetPosition: return "Target Position"
        case .targetRelativeHumidity: return "Target Relative Humidity"
        case .targetTemperature: return "Target Temperature"
        case .targetTiltAngle: return "Target Tilt Angle"
        case .targetVerticalTiltAngle: return "Target Vertical Tilt Angle"
        case .targetVisibilityState: return "Target Visibility State"
        case .temperatureDisplayUnits: return "Temperature Display Units"
        case .threadControlPoint: return "Thread Control Point"
        case .threadNodeCapabilities: return "Thread Node Capabilities"
        case .threadOpenthreadVersion: return "Thread OpenThread Version"
        case .threadStatus: return "Thread Status"
        case .token: return "Token"
        case .transmitPower: return "Transmit Power"
        case .valveType: return "Valve Type"
        case .version: return "Version"
        case .volatileOrganicCompoundDensity: return "Volatile Organic Compound Density"
        case .volume: return "Volume"
        case .volumeControlType: return "Volume Control Type"
        case .volumeSelector: return "Volume Selector"
        case .wiFiCapabilities: return "Wi-Fi Capabilities"
        case .wiFiConfigurationControl: return "Wi-Fi Configuration Control"
        case let .appleDefined(typeCode):
            let hex = String(typeCode, radix: 16).uppercased()
            return "Apple Defined (\(hex))"
        case let .custom(uuid):
            return "\(uuid)"
        }
    }
}
