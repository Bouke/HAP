import Foundation

extension Service {
    open class WiFiTransport: Service {
        // Required Characteristics
        public let currentTransport: GenericCharacteristic<Bool>
        public let wiFiCapabilities: GenericCharacteristic<UInt32>

        // Optional Characteristics
        public let wiFiConfigurationControl: GenericCharacteristic<Data>?

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
    }
}
