import Foundation

extension Service {
    open class CarbonMonoxideSensor: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            carbonMonoxideDetected = getOrCreateAppend(
                type: .carbonMonoxideDetected,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.carbonMonoxideDetected() })
            carbonMonoxideLevel = get(type: .carbonMonoxideLevel, characteristics: unwrapped)
            carbonMonoxidePeakLevel = get(type: .carbonMonoxidePeakLevel, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            statusActive = get(type: .statusActive, characteristics: unwrapped)
            statusFault = get(type: .statusFault, characteristics: unwrapped)
            statusLowBattery = get(type: .statusLowBattery, characteristics: unwrapped)
            statusTampered = get(type: .statusTampered, characteristics: unwrapped)
            super.init(type: .carbonMonoxideSensor, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let carbonMonoxideDetected: GenericCharacteristic<UInt8>

        // MARK: - Optional Characteristics
        public let carbonMonoxideLevel: GenericCharacteristic<Float>?
        public let carbonMonoxidePeakLevel: GenericCharacteristic<Float>?
        public let name: GenericCharacteristic<String>?
        public let statusActive: GenericCharacteristic<Bool>?
        public let statusFault: GenericCharacteristic<UInt8>?
        public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
        public let statusTampered: GenericCharacteristic<UInt8>?
    }
}
