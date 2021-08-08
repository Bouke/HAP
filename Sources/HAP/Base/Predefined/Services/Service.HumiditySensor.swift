import Foundation

extension Service {
    open class HumiditySensor: Service {
        // Required Characteristics
        public let currentRelativeHumidity: GenericCharacteristic<Float>

        // Optional Characteristics
        public let name: GenericCharacteristic<String>?
        public let statusActive: GenericCharacteristic<Bool>?
        public let statusFault: GenericCharacteristic<UInt8>?
        public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
        public let statusTampered: GenericCharacteristic<UInt8>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            currentRelativeHumidity = getOrCreateAppend(
                type: .currentRelativeHumidity,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentRelativeHumidity() })
            name = get(type: .name, characteristics: unwrapped)
            statusActive = get(type: .statusActive, characteristics: unwrapped)
            statusFault = get(type: .statusFault, characteristics: unwrapped)
            statusLowBattery = get(type: .statusLowBattery, characteristics: unwrapped)
            statusTampered = get(type: .statusTampered, characteristics: unwrapped)
            super.init(type: .humiditySensor, characteristics: unwrapped)
        }
    }
}
