import Foundation

extension Service {
    open class StatelessProgrammableSwitch: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            programmableSwitchEvent = getOrCreateAppend(
                type: .programmableSwitchEvent,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.programmableSwitchEvent() })
            name = get(type: .name, characteristics: unwrapped)
            labelIndex = get(type: .labelIndex, characteristics: unwrapped)
            super.init(type: .statelessProgrammableSwitch, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let programmableSwitchEvent: GenericCharacteristic<UInt8>

        // MARK: - Optional Characteristics
        public let name: GenericCharacteristic<String>?
        public let labelIndex: GenericCharacteristic<UInt8>?
    }
}
