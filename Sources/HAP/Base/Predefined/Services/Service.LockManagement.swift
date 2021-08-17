import Foundation

extension Service {
    open class LockManagement: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            lockControlPoint = getOrCreateAppend(
                type: .lockControlPoint,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.lockControlPoint() })
            version = getOrCreateAppend(
                type: .version,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.version() })
            administratorOnlyAccess = get(type: .administratorOnlyAccess, characteristics: unwrapped)
            audioFeedback = get(type: .audioFeedback, characteristics: unwrapped)
            currentDoorState = get(type: .currentDoorState, characteristics: unwrapped)
            lockManagementAutoSecurityTimeout = get(type: .lockManagementAutoSecurityTimeout, characteristics: unwrapped)
            lockLastKnownAction = get(type: .lockLastKnownAction, characteristics: unwrapped)
            logs = get(type: .logs, characteristics: unwrapped)
            motionDetected = get(type: .motionDetected, characteristics: unwrapped)
            super.init(type: .lockManagement, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let lockControlPoint: GenericCharacteristic<Data?>
        public let version: GenericCharacteristic<String>

        // MARK: - Optional Characteristics
        public let administratorOnlyAccess: GenericCharacteristic<Bool>?
        public let audioFeedback: GenericCharacteristic<Bool>?
        public let currentDoorState: GenericCharacteristic<Enums.CurrentDoorState>?
        public let lockManagementAutoSecurityTimeout: GenericCharacteristic<UInt32>?
        public let lockLastKnownAction: GenericCharacteristic<UInt8>?
        public let logs: GenericCharacteristic<Data>?
        public let motionDetected: GenericCharacteristic<Bool>?
    }
}
