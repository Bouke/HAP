import Foundation

extension Service {
    open class FirmwareUpdate: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            firmwareUpdateReadiness = getOrCreateAppend(
                type: .firmwareUpdateReadiness,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.firmwareUpdateReadiness() })
            firmwareUpdateStatus = getOrCreateAppend(
                type: .firmwareUpdateStatus,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.firmwareUpdateStatus() })
            stagedFirmwareVersion = get(type: .stagedFirmwareVersion, characteristics: unwrapped)
            supportedFirmwareUpdateConfiguration = get(type: .supportedFirmwareUpdateConfiguration, characteristics: unwrapped)
            super.init(type: .firmwareUpdate, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let firmwareUpdateReadiness: GenericCharacteristic<Data>
        public let firmwareUpdateStatus: GenericCharacteristic<Data>

        // MARK: - Optional Characteristics
        public let stagedFirmwareVersion: GenericCharacteristic<String>?
        public let supportedFirmwareUpdateConfiguration: GenericCharacteristic<Data>?
    }
}
