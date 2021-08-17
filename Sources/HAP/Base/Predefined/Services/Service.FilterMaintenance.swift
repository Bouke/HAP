import Foundation

extension Service {
    open class FilterMaintenance: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            filterChangeIndication = getOrCreateAppend(
                type: .filterChangeIndication,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.filterChangeIndication() })
            filterLifeLevel = get(type: .filterLifeLevel, characteristics: unwrapped)
            filterResetChangeIndication = get(type: .filterResetChangeIndication, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            super.init(type: .filterMaintenance, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let filterChangeIndication: GenericCharacteristic<Enums.FilterChangeIndication>

        // MARK: - Optional Characteristics
        public let filterLifeLevel: GenericCharacteristic<Float>?
        public let filterResetChangeIndication: GenericCharacteristic<UInt8?>?
        public let name: GenericCharacteristic<String>?
    }
}
