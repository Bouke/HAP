import Foundation

extension Service {
    open class TransferTransportManagement: Service {
        // Required Characteristics
        public let supportedTransferTransportConfiguration: GenericCharacteristic<Data>
        public let setupTransferTransport: GenericCharacteristic<Data?>

        // Optional Characteristics

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            supportedTransferTransportConfiguration = getOrCreateAppend(
                type: .supportedTransferTransportConfiguration,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.supportedTransferTransportConfiguration() })
            setupTransferTransport = getOrCreateAppend(
                type: .setupTransferTransport,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.setupTransferTransport() })
            super.init(type: .transferTransportManagement, characteristics: unwrapped)
        }
    }
}
