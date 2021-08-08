import Foundation

extension Service {
    open class Fan: Service {
        // Required Characteristics
        public let powerState: GenericCharacteristic<Bool>

        // Optional Characteristics
        public let name: GenericCharacteristic<String>?
        public let rotationDirection: GenericCharacteristic<Enums.RotationDirection>?
        public let rotationSpeed: GenericCharacteristic<Float>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            powerState = getOrCreateAppend(
                type: .powerState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.powerState() })
            name = get(type: .name, characteristics: unwrapped)
            rotationDirection = get(type: .rotationDirection, characteristics: unwrapped)
            rotationSpeed = get(type: .rotationSpeed, characteristics: unwrapped)
            super.init(type: .fan, characteristics: unwrapped)
        }
    }
}
