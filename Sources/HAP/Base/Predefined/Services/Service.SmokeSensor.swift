import Foundation

extension Service {
    open class SmokeSensor: Service {
        // Required Characteristics
        public let smokeDetected: GenericCharacteristic<Enums.SmokeDetected>

        // Optional Characteristics
        public let name: GenericCharacteristic<String>?
        public let statusActive: GenericCharacteristic<Bool>?
        public let statusFault: GenericCharacteristic<UInt8>?
        public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
        public let statusTampered: GenericCharacteristic<UInt8>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            smokeDetected = getOrCreateAppend(
                type: .smokeDetected,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.smokeDetected() })
            name = get(type: .name, characteristics: unwrapped)
            statusActive = get(type: .statusActive, characteristics: unwrapped)
            statusFault = get(type: .statusFault, characteristics: unwrapped)
            statusLowBattery = get(type: .statusLowBattery, characteristics: unwrapped)
            statusTampered = get(type: .statusTampered, characteristics: unwrapped)
            super.init(type: .smokeSensor, characteristics: unwrapped)
        }
    }
}
