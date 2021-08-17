import Foundation

extension Service {
    open class Television: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            active = getOrCreateAppend(
                type: .active,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.active() })
            activeIdentifier = getOrCreateAppend(
                type: .activeIdentifier,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.activeIdentifier() })
            configuredName = getOrCreateAppend(
                type: .configuredName,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.configuredName() })
            remoteKey = getOrCreateAppend(
                type: .remoteKey,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.remoteKey() })
            sleepDiscoveryMode = getOrCreateAppend(
                type: .sleepDiscoveryMode,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.sleepDiscoveryMode() })
            brightness = get(type: .brightness, characteristics: unwrapped)
            closedCaptions = get(type: .closedCaptions, characteristics: unwrapped)
            displayOrder = get(type: .displayOrder, characteristics: unwrapped)
            currentMediaState = get(type: .currentMediaState, characteristics: unwrapped)
            targetMediaState = get(type: .targetMediaState, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            pictureMode = get(type: .pictureMode, characteristics: unwrapped)
            powerModeSelection = get(type: .powerModeSelection, characteristics: unwrapped)
            super.init(type: .television, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let active: GenericCharacteristic<Enums.Active>
        public let activeIdentifier: GenericCharacteristic<UInt32>
        public let configuredName: GenericCharacteristic<String>
        public let remoteKey: GenericCharacteristic<Enums.RemoteKey?>
        public let sleepDiscoveryMode: GenericCharacteristic<Enums.SleepDiscoveryMode>

        // MARK: - Optional Characteristics
        public let brightness: GenericCharacteristic<Int>?
        public let closedCaptions: GenericCharacteristic<Enums.ClosedCaptions>?
        public let displayOrder: GenericCharacteristic<Data>?
        public let currentMediaState: GenericCharacteristic<UInt8>?
        public let targetMediaState: GenericCharacteristic<Enums.TargetMediaState>?
        public let name: GenericCharacteristic<String>?
        public let pictureMode: GenericCharacteristic<Enums.PictureMode>?
        public let powerModeSelection: GenericCharacteristic<Enums.PowerModeSelection?>?
    }
}
