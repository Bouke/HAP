import Foundation

extension Service {
    open class Switch: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            powerState = getOrCreateAppend(
                type: .powerState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.powerState() })
            name = get(type: .name, characteristics: unwrapped)
            super.init(type: .`switch`, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let powerState: GenericCharacteristic<Bool>

        // MARK: - Optional Characteristics
        public let name: GenericCharacteristic<String>?
    }
}
