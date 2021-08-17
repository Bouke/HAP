import Foundation

extension Service {
    open class Info: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            identify = getOrCreateAppend(
                type: .identify,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.identify() })
            manufacturer = getOrCreateAppend(
                type: .manufacturer,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.manufacturer() })
            model = getOrCreateAppend(
                type: .model,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.model() })
            name = getOrCreateAppend(
                type: .name,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.name() })
            serialNumber = getOrCreateAppend(
                type: .serialNumber,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.serialNumber() })
            accessoryFlags = get(type: .accessoryFlags, characteristics: unwrapped)
            applicationMatchingIdentifier = get(type: .applicationMatchingIdentifier, characteristics: unwrapped)
            configuredName = get(type: .configuredName, characteristics: unwrapped)
            firmwareRevision = get(type: .firmwareRevision, characteristics: unwrapped)
            hardwareRevision = get(type: .hardwareRevision, characteristics: unwrapped)
            softwareRevision = get(type: .softwareRevision, characteristics: unwrapped)
            productData = get(type: .productData, characteristics: unwrapped)
            super.init(type: .info, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let identify: GenericCharacteristic<Bool?>
        public let manufacturer: GenericCharacteristic<String>
        public let model: GenericCharacteristic<String>
        public let name: GenericCharacteristic<String>
        public let serialNumber: GenericCharacteristic<String>

        // MARK: - Optional Characteristics
        public let accessoryFlags: GenericCharacteristic<UInt32>?
        public let applicationMatchingIdentifier: GenericCharacteristic<Data>?
        public let configuredName: GenericCharacteristic<String>?
        public let firmwareRevision: GenericCharacteristic<String>?
        public let hardwareRevision: GenericCharacteristic<String>?
        public let softwareRevision: GenericCharacteristic<String>?
        public let productData: GenericCharacteristic<Data>?
    }
}
