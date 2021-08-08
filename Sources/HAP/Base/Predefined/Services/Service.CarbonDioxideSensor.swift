import Foundation

extension Service {
    open class CarbonDioxideSensor: Service {
        // Required Characteristics
        public let carbonDioxideDetected: GenericCharacteristic<Enums.CarbonDioxideDetected>

        // Optional Characteristics
        public let carbonDioxideLevel: GenericCharacteristic<Float>?
        public let carbonDioxidePeakLevel: GenericCharacteristic<Float>?
        public let name: GenericCharacteristic<String>?
        public let statusActive: GenericCharacteristic<Bool>?
        public let statusFault: GenericCharacteristic<UInt8>?
        public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
        public let statusTampered: GenericCharacteristic<UInt8>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            carbonDioxideDetected = getOrCreateAppend(
                type: .carbonDioxideDetected,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.carbonDioxideDetected() })
            carbonDioxideLevel = get(type: .carbonDioxideLevel, characteristics: unwrapped)
            carbonDioxidePeakLevel = get(type: .carbonDioxidePeakLevel, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            statusActive = get(type: .statusActive, characteristics: unwrapped)
            statusFault = get(type: .statusFault, characteristics: unwrapped)
            statusLowBattery = get(type: .statusLowBattery, characteristics: unwrapped)
            statusTampered = get(type: .statusTampered, characteristics: unwrapped)
            super.init(type: .carbonDioxideSensor, characteristics: unwrapped)
        }
    }
}
