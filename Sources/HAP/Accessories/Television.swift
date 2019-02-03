
extension Accessory {
    open class Television: Accessory {
        public let television = Service.Television()
        public let speaker = Service.TelevisionSpeaker()
        public var sources = [Service.InputSource]()

        public init(info: Service.Info, inputs: [(String, InputSourceType)], additionalServices: [Service] = []) {

            precondition(inputs.count > 0)
            var i: UInt32 = 0
            for (name, type) in inputs {
                sources.append(Service.InputSource(identifier: i, name: name, input: type))
                i = i+1
            }
            super.init(info: info, type: .television, services: ([television, speaker] + sources as [Service]) + additionalServices)
            speaker.name.value = "Speaker"
            television.configuredName.value = info.name.value
            television.activeIdentifier.value = sources[0].identifier.value
            television.addLinkedService(speaker)

            for source in sources {
                television.addLinkedService(source)
            }
        }
    }
}

public enum Active: UInt8, CharacteristicValueType {
    case inactive = 0
    case active = 1
}

public typealias ActiveIdentifier = UInt32
public typealias ConfiguredName = String


public enum SleepDiscoveryMode: UInt8, CharacteristicValueType {
    case notDiscoverable = 0
    case alwaysDiscoverable = 1
}

public enum ClosedCaptions: UInt8, CharacteristicValueType {
    case disabled = 0
    case enabled = 1
}

public typealias CurrentMediaState = UInt8

public enum TargetMediaState: UInt8, CharacteristicValueType {
    case play = 0
    case pause = 1
    case stop = 2
}

public enum PictureMode: UInt16, CharacteristicValueType {
    case other = 0
    case standard = 1
    case calibrated = 2
    case calibratedDark = 3
    case vivid = 4
    case game = 5
    case computer = 6
    case custom = 7
    case _other8 = 8
    case _other9 = 9
    case _other10 = 10
    case _other11 = 11
    case _other12 = 12
    case _other13 = 13
}

public enum PowerModeSelection: UInt8, CharacteristicValueType {
    case show = 0
    case hide = 1
}

public enum RemoteKey: UInt8, CharacteristicValueType {
    case rewind = 0
    case fastForward = 1
    case nextTrack = 2
    case previousTrack = 3
    case arrowUp = 4
    case arrowDown = 5
    case arrowLeft = 6
    case arrowRight = 7
    case select = 8
    case back = 9
    case exit = 10
    case playPause = 11
    case information = 15
    case _other = 16
}

public enum InputSourceType: UInt8, CharacteristicValueType {
    case other = 0
    case homeScreen = 1
    case tuner = 2
    case hdmi = 3
    case compositeVideo = 4
    case sVideo = 5
    case componentVideo = 6
    case dvi = 7
    case airplay = 8
    case usb = 9
    case application = 10
}

public enum InputDeviceType: UInt8, CharacteristicValueType {
    case other = 0
    case tv = 1
    case recording = 2
    case tuner = 3
    case playback = 4
    case audioSystem = 5
}

public typealias Name = String
public typealias Mute = Bool

public enum CurrentVisibilityState: UInt8, CharacteristicValueType {
    case shown = 0
    case hidden = 1
}

public enum TargetVisibilityState: UInt8, CharacteristicValueType {
    case shown = 0
    case hidden = 1
}

public enum VolumeControlType: UInt8, CharacteristicValueType {
    case none = 0
    case relative = 1
    case relativeWithCurrent = 2
    case absolute = 3
}

public enum VolumeSelector: UInt8, CharacteristicValueType {
    case increment = 0
    case decrement = 1
}

public enum IsConfigured: UInt8, CharacteristicValueType {
    case notConfigured = 0
    case configured = 1
}


extension Service {
    open class Television: Service {
        public let active = GenericCharacteristic<Active>(
            type: .active,
            value: .inactive,
            maxValue: 1,
            minValue: 0)
        public let activeIdentifier = GenericCharacteristic<ActiveIdentifier>(
            type: .activeIdentifier,
            value: 1)
        public let configuredName = GenericCharacteristic<ConfiguredName>(
            type: .configuredName)
        public let sleepDiscoveryMode = GenericCharacteristic<SleepDiscoveryMode>(
            type: .sleepDiscoveryMode,
            value: .alwaysDiscoverable,
            permissions: [.read, .events])


        // Optional Characteristics

        
        public let brightness = GenericCharacteristic<Brightness>(
            type: .brightness,
            value: 100,
            unit: .percentage,
            maxValue: 100,
            minValue: 0,
            minStep: 1)

        public let closedCaptions = GenericCharacteristic<ClosedCaptions>(
            type: .closedCaptions,
            value: .disabled)
//     TLV8 type - not yet implemented
//        public let displayOrder = GenericCharacteristic<DisplayOrder>(
//            type: .displayOrder,
//            value: .disarmed)
        public let currentMediaState = GenericCharacteristic<CurrentMediaState>(
            type: .currentMediaState,
            value: 0,
            permissions: [.read, .events],
            maxValue: 3,
            minValue: 0)
        public let targetMediaState = GenericCharacteristic<TargetMediaState>(
            type: .targetMediaState,
            value: .play)
        public let pictureMode = GenericCharacteristic<PictureMode>(
            type: .pictureMode,
            value: .standard)
        public let powerModeSelection = GenericCharacteristic<PowerModeSelection>(
            type: .powerModeSelection,
            value: .show,
            permissions: [.write],
            maxValue: 1,
            minValue: 0)
        public let remoteKey = GenericCharacteristic<RemoteKey>(
            type: .remoteKey,
            permissions: [.write],
            maxValue: 16,
            minValue: 0)

        public init() {
            super.init(type: .television, characteristics: [active, activeIdentifier, configuredName, sleepDiscoveryMode, powerModeSelection, remoteKey])
            self.primary = true
        }
    }
}


extension Service {
    open class InputSource: Service {
        public let configuredName = GenericCharacteristic<ConfiguredName>(
            type: .configuredName)
        public let inputSourceType = GenericCharacteristic<InputSourceType>(
            type: .inputSourceType,
            permissions: [.read, .events],
            maxValue: 10,
            minValue: 0)
        public let isConfigured = GenericCharacteristic<IsConfigured>(
            type: .isConfigured,
            value: .configured,
            maxValue: 1,
            minValue: 0)
        public let currentVisibilityState = GenericCharacteristic<CurrentVisibilityState>(
            type: .currentVisibilityState,
            value: .shown,
            permissions: [.read, .events],
            maxValue: 3,
            minValue: 0)

        // Optional Characteristics

        public let identifier = GenericCharacteristic<UInt32>(
            type: .identifier,
            permissions: [.read],
            minValue: 0,
            minStep: 1)
        public let inputDeviceType = GenericCharacteristic<InputDeviceType>(
            type: .inputDeviceType,
            value: .other,
            permissions: [.read, .events],
            maxValue: 5,
            minValue: 0)
       public let targetVisibilityState = GenericCharacteristic<TargetVisibilityState>(
            type: .targetVisibilityState,
            value: .shown,
            maxValue: 1,
            minValue: 0)

        public let name = GenericCharacteristic<Name>(
            type: .name,
            permissions: [.read])

        public init(identifier: UInt32, name: String, input: InputSourceType) {
            super.init(type: .inputSource, characteristics: [configuredName, inputSourceType, isConfigured, currentVisibilityState, self.identifier, self.name])

            self.name.value = name.replacingOccurrences(of: " ", with: "")
            configuredName.value = name
            inputSourceType.value = input
            self.identifier.value = identifier
        }
    }
}

extension Service {
    open class TelevisionSpeaker: Service {
        public let mute = GenericCharacteristic<Mute>(
            type: .mute,
            value: false)

        // Optional Characteristics

        public let active = GenericCharacteristic<Active>(
            type: .active,
            value: .active,
            maxValue: 1,
            minValue: 0)
       public let volume = GenericCharacteristic<Int>(
            type: .volume,
            value: 10,
            unit: .percentage,
            maxValue: 100,
            minValue: 0,
            minStep: 1)
        public let volumeControlType = GenericCharacteristic<VolumeControlType>(
            type: .volumeControlType,
            value: .absolute,
            permissions: [.read, .events],
            maxValue: 3,
            minValue: 0)
        public let volumeSelector = GenericCharacteristic<VolumeSelector>(
            type: .volumeSelector,
            permissions: [.write],
            maxValue: 1,
            minValue: 0)
        public let name = GenericCharacteristic<Name>(
            type: .name,
            permissions: [.read])

        public init() {
            super.init(type: .televisionSpeaker, characteristics: [name, mute, active, volumeControlType, volumeSelector, volume])
        }
    }
}
