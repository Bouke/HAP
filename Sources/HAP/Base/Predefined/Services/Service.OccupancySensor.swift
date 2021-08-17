import Foundation

extension Service {
    open class OccupancySensor: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            occupancyDetected = getOrCreateAppend(
                type: .occupancyDetected,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.occupancyDetected() })
            name = get(type: .name, characteristics: unwrapped)
            statusActive = get(type: .statusActive, characteristics: unwrapped)
            statusFault = get(type: .statusFault, characteristics: unwrapped)
            statusLowBattery = get(type: .statusLowBattery, characteristics: unwrapped)
            statusTampered = get(type: .statusTampered, characteristics: unwrapped)
            super.init(type: .occupancySensor, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let occupancyDetected: GenericCharacteristic<Enums.OccupancyDetected>

        // MARK: - Optional Characteristics
        public let name: GenericCharacteristic<String>?
        public let statusActive: GenericCharacteristic<Bool>?
        public let statusFault: GenericCharacteristic<UInt8>?
        public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
        public let statusTampered: GenericCharacteristic<UInt8>?
    }
}
