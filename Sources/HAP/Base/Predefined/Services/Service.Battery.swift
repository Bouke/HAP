import Foundation

extension Service {
    open class Battery: Service {
        // Required Characteristics
        public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>

        // Optional Characteristics
        public let batteryLevel: GenericCharacteristic<UInt8>?
        public let chargingState: GenericCharacteristic<Enums.ChargingState>?
        public let name: GenericCharacteristic<String>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            statusLowBattery = getOrCreateAppend(
                type: .statusLowBattery,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.statusLowBattery() })
            batteryLevel = get(type: .batteryLevel, characteristics: unwrapped)
            chargingState = get(type: .chargingState, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            super.init(type: .battery, characteristics: unwrapped)
        }
    }
}
