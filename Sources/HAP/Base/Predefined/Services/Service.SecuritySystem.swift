import Foundation

extension Service {
    open class SecuritySystem: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            securitySystemCurrentState = getOrCreateAppend(
                type: .securitySystemCurrentState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.securitySystemCurrentState() })
            securitySystemTargetState = getOrCreateAppend(
                type: .securitySystemTargetState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.securitySystemTargetState() })
            name = get(type: .name, characteristics: unwrapped)
            securitySystemAlarmType = get(type: .securitySystemAlarmType, characteristics: unwrapped)
            statusFault = get(type: .statusFault, characteristics: unwrapped)
            statusTampered = get(type: .statusTampered, characteristics: unwrapped)
            super.init(type: .securitySystem, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let securitySystemCurrentState: GenericCharacteristic<Enums.SecuritySystemCurrentState>
        public let securitySystemTargetState: GenericCharacteristic<Enums.SecuritySystemTargetState>

        // MARK: - Optional Characteristics
        public let name: GenericCharacteristic<String>?
        public let securitySystemAlarmType: GenericCharacteristic<UInt8>?
        public let statusFault: GenericCharacteristic<UInt8>?
        public let statusTampered: GenericCharacteristic<UInt8>?
    }
}
