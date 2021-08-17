import Foundation

extension Service {
    open class Diagnostics: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            supportedDiagnosticsSnapshot = getOrCreateAppend(
                type: .supportedDiagnosticsSnapshot,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.supportedDiagnosticsSnapshot() })
            super.init(type: .diagnostics, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let supportedDiagnosticsSnapshot: GenericCharacteristic<Data>

        // MARK: - Optional Characteristics
    }
}
