import Foundation

extension Service {
    open class StatefulProgrammableSwitch: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            programmableSwitchEvent = getOrCreateAppend(
                type: .programmableSwitchEvent,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.programmableSwitchEvent() })
            programmableSwitchOutputState = getOrCreateAppend(
                type: .programmableSwitchOutputState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.programmableSwitchOutputState() })
            name = get(type: .name, characteristics: unwrapped)
            super.init(type: .statefulProgrammableSwitch, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let programmableSwitchEvent: GenericCharacteristic<UInt8>
        public let programmableSwitchOutputState: GenericCharacteristic<UInt8>

        // MARK: - Optional Characteristics
        public let name: GenericCharacteristic<String>?
    }
}
