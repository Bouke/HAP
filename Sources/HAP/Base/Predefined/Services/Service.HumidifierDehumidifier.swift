import Foundation

extension Service {
    open class HumidifierDehumidifier: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            active = getOrCreateAppend(
                type: .active,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.active() })
            currentHumidifierDehumidifierState = getOrCreateAppend(
                type: .currentHumidifierDehumidifierState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentHumidifierDehumidifierState() })
            targetHumidifierDehumidifierState = getOrCreateAppend(
                type: .targetHumidifierDehumidifierState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.targetHumidifierDehumidifierState() })
            currentRelativeHumidity = getOrCreateAppend(
                type: .currentRelativeHumidity,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentRelativeHumidity() })
            lockPhysicalControls = get(type: .lockPhysicalControls, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            relativeHumidityDehumidifierThreshold = get(type: .relativeHumidityDehumidifierThreshold, characteristics: unwrapped)
            relativeHumidityHumidifierThreshold = get(type: .relativeHumidityHumidifierThreshold, characteristics: unwrapped)
            rotationSpeed = get(type: .rotationSpeed, characteristics: unwrapped)
            swingMode = get(type: .swingMode, characteristics: unwrapped)
            currentWaterLevel = get(type: .currentWaterLevel, characteristics: unwrapped)
            super.init(type: .humidifierDehumidifier, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let active: GenericCharacteristic<Enums.Active>
        public let currentHumidifierDehumidifierState: GenericCharacteristic<Enums.CurrentHumidifierDehumidifierState>
        public let targetHumidifierDehumidifierState: GenericCharacteristic<Enums.TargetHumidifierDehumidifierState>
        public let currentRelativeHumidity: GenericCharacteristic<Float>

        // MARK: - Optional Characteristics
        public let lockPhysicalControls: GenericCharacteristic<UInt8>?
        public let name: GenericCharacteristic<String>?
        public let relativeHumidityDehumidifierThreshold: GenericCharacteristic<Float>?
        public let relativeHumidityHumidifierThreshold: GenericCharacteristic<Float>?
        public let rotationSpeed: GenericCharacteristic<Float>?
        public let swingMode: GenericCharacteristic<UInt8>?
        public let currentWaterLevel: GenericCharacteristic<Float>?
    }
}
