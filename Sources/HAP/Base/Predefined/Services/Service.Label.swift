import Foundation

extension Service {
    open class Label: Service {
        // Required Characteristics
        public let labelNamespace: GenericCharacteristic<UInt8>

        // Optional Characteristics

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            labelNamespace = getOrCreateAppend(
                type: .labelNamespace,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.labelNamespace() })
            super.init(type: .label, characteristics: unwrapped)
        }
    }
}
