import Foundation

extension Service {
    open class GarageDoorOpener: Service {
        // Required Characteristics
        public let currentDoorState: GenericCharacteristic<Enums.CurrentDoorState>
        public let targetDoorState: GenericCharacteristic<Enums.TargetDoorState>
        public let obstructionDetected: GenericCharacteristic<Bool>

        // Optional Characteristics
        public let lockCurrentState: GenericCharacteristic<Enums.LockCurrentState>?
        public let lockTargetState: GenericCharacteristic<Enums.LockTargetState>?
        public let name: GenericCharacteristic<String>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            currentDoorState = getOrCreateAppend(
                type: .currentDoorState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentDoorState() })
            targetDoorState = getOrCreateAppend(
                type: .targetDoorState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.targetDoorState() })
            obstructionDetected = getOrCreateAppend(
                type: .obstructionDetected,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.obstructionDetected() })
            lockCurrentState = get(type: .lockCurrentState, characteristics: unwrapped)
            lockTargetState = get(type: .lockTargetState, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            super.init(type: .garageDoorOpener, characteristics: unwrapped)
        }
    }
}
