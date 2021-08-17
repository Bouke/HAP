import Foundation

extension Service {
    open class FanV2: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            active = getOrCreateAppend(
                type: .active,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.active() })
            currentFanState = get(type: .currentFanState, characteristics: unwrapped)
            targetFanState = get(type: .targetFanState, characteristics: unwrapped)
            lockPhysicalControls = get(type: .lockPhysicalControls, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            rotationDirection = get(type: .rotationDirection, characteristics: unwrapped)
            rotationSpeed = get(type: .rotationSpeed, characteristics: unwrapped)
            swingMode = get(type: .swingMode, characteristics: unwrapped)
            super.init(type: .fanV2, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let active: GenericCharacteristic<Enums.Active>

        // MARK: - Optional Characteristics
        public let currentFanState: GenericCharacteristic<Enums.CurrentFanState>?
        public let targetFanState: GenericCharacteristic<Enums.TargetFanState>?
        public let lockPhysicalControls: GenericCharacteristic<UInt8>?
        public let name: GenericCharacteristic<String>?
        public let rotationDirection: GenericCharacteristic<Enums.RotationDirection>?
        public let rotationSpeed: GenericCharacteristic<Float>?
        public let swingMode: GenericCharacteristic<UInt8>?
    }
}
