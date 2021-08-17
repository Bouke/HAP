import Foundation

extension Service {
    open class Valve: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            active = getOrCreateAppend(
                type: .active,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.active() })
            inUse = getOrCreateAppend(
                type: .inUse,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.inUse() })
            valveType = getOrCreateAppend(
                type: .valveType,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.valveType() })
            isConfigured = get(type: .isConfigured, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            remainingDuration = get(type: .remainingDuration, characteristics: unwrapped)
            labelIndex = get(type: .labelIndex, characteristics: unwrapped)
            setDuration = get(type: .setDuration, characteristics: unwrapped)
            statusFault = get(type: .statusFault, characteristics: unwrapped)
            super.init(type: .valve, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let active: GenericCharacteristic<Enums.Active>
        public let inUse: GenericCharacteristic<UInt8>
        public let valveType: GenericCharacteristic<UInt8>

        // MARK: - Optional Characteristics
        public let isConfigured: GenericCharacteristic<Enums.IsConfigured>?
        public let name: GenericCharacteristic<String>?
        public let remainingDuration: GenericCharacteristic<UInt32>?
        public let labelIndex: GenericCharacteristic<UInt8>?
        public let setDuration: GenericCharacteristic<UInt32>?
        public let statusFault: GenericCharacteristic<UInt8>?
    }
}
