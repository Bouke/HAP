import Foundation

extension Service {
    open class MotionSensor: Service {
        // Required Characteristics
        public let motionDetected: GenericCharacteristic<Bool>

        // Optional Characteristics
        public let name: GenericCharacteristic<String>?
        public let statusActive: GenericCharacteristic<Bool>?
        public let statusFault: GenericCharacteristic<UInt8>?
        public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
        public let statusTampered: GenericCharacteristic<UInt8>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            motionDetected = getOrCreateAppend(
                type: .motionDetected,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.motionDetected() })
            name = get(type: .name, characteristics: unwrapped)
            statusActive = get(type: .statusActive, characteristics: unwrapped)
            statusFault = get(type: .statusFault, characteristics: unwrapped)
            statusLowBattery = get(type: .statusLowBattery, characteristics: unwrapped)
            statusTampered = get(type: .statusTampered, characteristics: unwrapped)
            super.init(type: .motionSensor, characteristics: unwrapped)
        }
    }
}
