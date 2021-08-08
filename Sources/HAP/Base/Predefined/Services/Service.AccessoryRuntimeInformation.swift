import Foundation

extension Service {
    open class AccessoryRuntimeInformation: Service {
        // Required Characteristics
        public let ping: GenericCharacteristic<Data>

        // Optional Characteristics
        public let activityInterval: GenericCharacteristic<UInt32>?
        public let heartBeat: GenericCharacteristic<UInt32>?
        public let sleepInterval: GenericCharacteristic<UInt32>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            ping = getOrCreateAppend(
                type: .ping,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.ping() })
            activityInterval = get(type: .activityInterval, characteristics: unwrapped)
            heartBeat = get(type: .heartBeat, characteristics: unwrapped)
            sleepInterval = get(type: .sleepInterval, characteristics: unwrapped)
            super.init(type: .accessoryRuntimeInformation, characteristics: unwrapped)
        }
    }
}
