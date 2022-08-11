import Foundation

extension Service {
    open class InputSource: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            configuredName = getOrCreateAppend(
                type: .configuredName,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.configuredName() })
            inputSourceType = getOrCreateAppend(
                type: .inputSourceType,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.inputSourceType() })
            isConfigured = getOrCreateAppend(
                type: .isConfigured,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.isConfigured() })
            name = getOrCreateAppend(
                type: .name,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.name() })
            currentVisibilityState = getOrCreateAppend(
                type: .currentVisibilityState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentVisibilityState() })
            inputDeviceType = get(type: .inputDeviceType, characteristics: unwrapped)
            targetVisibilityState = get(type: .targetVisibilityState, characteristics: unwrapped)
            super.init(type: .inputSource, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let configuredName: GenericCharacteristic<String>
        public let inputSourceType: GenericCharacteristic<Enums.InputSourceType>
        public let isConfigured: GenericCharacteristic<Enums.IsConfigured>
        public let name: GenericCharacteristic<String>
        public let currentVisibilityState: GenericCharacteristic<Enums.CurrentVisibilityState>

        // MARK: - Optional Characteristics
        public let inputDeviceType: GenericCharacteristic<Enums.InputDeviceType>?
        public let targetVisibilityState: GenericCharacteristic<Enums.TargetVisibilityState>?
    }
}
