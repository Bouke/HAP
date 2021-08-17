import Foundation

extension Service {
    open class Faucet: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            active = getOrCreateAppend(
                type: .active,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.active() })
            name = get(type: .name, characteristics: unwrapped)
            statusFault = get(type: .statusFault, characteristics: unwrapped)
            super.init(type: .faucet, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let active: GenericCharacteristic<Enums.Active>

        // MARK: - Optional Characteristics
        public let name: GenericCharacteristic<String>?
        public let statusFault: GenericCharacteristic<UInt8>?
    }
}
