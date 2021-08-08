import Foundation

extension Service {
    open class Window: Service {
        // Required Characteristics
        public let currentPosition: GenericCharacteristic<UInt8>
        public let positionState: GenericCharacteristic<Enums.PositionState>
        public let targetPosition: GenericCharacteristic<UInt8>

        // Optional Characteristics
        public let name: GenericCharacteristic<String>?
        public let obstructionDetected: GenericCharacteristic<Bool>?
        public let holdPosition: GenericCharacteristic<Bool?>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            currentPosition = getOrCreateAppend(
                type: .currentPosition,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentPosition() })
            positionState = getOrCreateAppend(
                type: .positionState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.positionState() })
            targetPosition = getOrCreateAppend(
                type: .targetPosition,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.targetPosition() })
            name = get(type: .name, characteristics: unwrapped)
            obstructionDetected = get(type: .obstructionDetected, characteristics: unwrapped)
            holdPosition = get(type: .holdPosition, characteristics: unwrapped)
            super.init(type: .window, characteristics: unwrapped)
        }
    }
}
