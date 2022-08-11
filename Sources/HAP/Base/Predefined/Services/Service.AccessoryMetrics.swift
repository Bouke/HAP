import Foundation

extension Service {
    open class AccessoryMetrics: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            active = getOrCreateAppend(
                type: .active,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.active() })
            metricsBufferFullState = getOrCreateAppend(
                type: .metricsBufferFullState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.metricsBufferFullState() })
            supportedMetrics = getOrCreateAppend(
                type: .supportedMetrics,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.supportedMetrics() })
            super.init(type: .accessoryMetrics, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let active: GenericCharacteristic<Enums.Active>
        public let metricsBufferFullState: GenericCharacteristic<Bool>
        public let supportedMetrics: GenericCharacteristic<Data>

        // MARK: - Optional Characteristics
    }
}
