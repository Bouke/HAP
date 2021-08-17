import Foundation

extension Service {
    open class AirPurifier: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            active = getOrCreateAppend(
                type: .active,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.active() })
            currentAirPurifierState = getOrCreateAppend(
                type: .currentAirPurifierState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentAirPurifierState() })
            targetAirPurifierState = getOrCreateAppend(
                type: .targetAirPurifierState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.targetAirPurifierState() })
            lockPhysicalControls = get(type: .lockPhysicalControls, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            rotationSpeed = get(type: .rotationSpeed, characteristics: unwrapped)
            swingMode = get(type: .swingMode, characteristics: unwrapped)
            super.init(type: .airPurifier, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let active: GenericCharacteristic<Enums.Active>
        public let currentAirPurifierState: GenericCharacteristic<Enums.CurrentAirPurifierState>
        public let targetAirPurifierState: GenericCharacteristic<Enums.TargetAirPurifierState>

        // MARK: - Optional Characteristics
        public let lockPhysicalControls: GenericCharacteristic<UInt8>?
        public let name: GenericCharacteristic<String>?
        public let rotationSpeed: GenericCharacteristic<Float>?
        public let swingMode: GenericCharacteristic<UInt8>?
    }
}
