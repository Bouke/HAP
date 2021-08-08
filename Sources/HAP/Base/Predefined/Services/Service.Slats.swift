import Foundation

extension Service {
    open class Slats: Service {
        // Required Characteristics
        public let currentSlatState: GenericCharacteristic<Enums.CurrentSlatState>
        public let slatType: GenericCharacteristic<UInt8>

        // Optional Characteristics
        public let name: GenericCharacteristic<String>?
        public let swingMode: GenericCharacteristic<UInt8>?
        public let currentTiltAngle: GenericCharacteristic<Int>?
        public let targetTiltAngle: GenericCharacteristic<Int>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            currentSlatState = getOrCreateAppend(
                type: .currentSlatState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentSlatState() })
            slatType = getOrCreateAppend(
                type: .slatType,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.slatType() })
            name = get(type: .name, characteristics: unwrapped)
            swingMode = get(type: .swingMode, characteristics: unwrapped)
            currentTiltAngle = get(type: .currentTiltAngle, characteristics: unwrapped)
            targetTiltAngle = get(type: .targetTiltAngle, characteristics: unwrapped)
            super.init(type: .slats, characteristics: unwrapped)
        }
    }
}
