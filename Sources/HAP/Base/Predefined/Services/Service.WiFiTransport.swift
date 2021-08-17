import Foundation

extension Service {
    open class WiFiTransport: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            currentTransport = getOrCreateAppend(
                type: .currentTransport,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentTransport() })
            wiFiCapabilities = getOrCreateAppend(
                type: .wiFiCapabilities,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.wiFiCapabilities() })
            wiFiConfigurationControl = get(type: .wiFiConfigurationControl, characteristics: unwrapped)
            super.init(type: .wiFiTransport, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let currentTransport: GenericCharacteristic<Bool>
        public let wiFiCapabilities: GenericCharacteristic<UInt32>

        // MARK: - Optional Characteristics
        public let wiFiConfigurationControl: GenericCharacteristic<Data>?
    }
}
