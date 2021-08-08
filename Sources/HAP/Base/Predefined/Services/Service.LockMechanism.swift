import Foundation

extension Service {
    open class LockMechanism: Service {
        // Required Characteristics
        public let lockCurrentState: GenericCharacteristic<Enums.LockCurrentState>
        public let lockTargetState: GenericCharacteristic<Enums.LockTargetState>

        // Optional Characteristics
        public let name: GenericCharacteristic<String>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            lockCurrentState = getOrCreateAppend(
                type: .lockCurrentState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.lockCurrentState() })
            lockTargetState = getOrCreateAppend(
                type: .lockTargetState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.lockTargetState() })
            name = get(type: .name, characteristics: unwrapped)
            super.init(type: .lockMechanism, characteristics: unwrapped)
        }
    }
}
