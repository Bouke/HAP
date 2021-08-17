import Foundation

extension Service {
    open class ThreadTransport: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            currentTransport = getOrCreateAppend(
                type: .currentTransport,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentTransport() })
            threadControlPoint = getOrCreateAppend(
                type: .threadControlPoint,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.threadControlPoint() })
            threadNodeCapabilities = getOrCreateAppend(
                type: .threadNodeCapabilities,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.threadNodeCapabilities() })
            threadStatus = getOrCreateAppend(
                type: .threadStatus,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.threadStatus() })
            ccaEnergyDetectThreshold = get(type: .ccaEnergyDetectThreshold, characteristics: unwrapped)
            ccaSignalDetectThreshold = get(type: .ccaSignalDetectThreshold, characteristics: unwrapped)
            eventRetransmissionMaximum = get(type: .eventRetransmissionMaximum, characteristics: unwrapped)
            eventTransmissionCounters = get(type: .eventTransmissionCounters, characteristics: unwrapped)
            macRetransmissionMaximum = get(type: .macRetransmissionMaximum, characteristics: unwrapped)
            macTransmissionCounters = get(type: .macTransmissionCounters, characteristics: unwrapped)
            receiverSensitivity = get(type: .receiverSensitivity, characteristics: unwrapped)
            receivedSignalStrengthIndication = get(type: .receivedSignalStrengthIndication, characteristics: unwrapped)
            signalToNoiseRatio = get(type: .signalToNoiseRatio, characteristics: unwrapped)
            threadOpenthreadVersion = get(type: .threadOpenthreadVersion, characteristics: unwrapped)
            transmitPower = get(type: .transmitPower, characteristics: unwrapped)
            maximumTransmitPower = get(type: .maximumTransmitPower, characteristics: unwrapped)
            super.init(type: .threadTransport, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let currentTransport: GenericCharacteristic<Bool>
        public let threadControlPoint: GenericCharacteristic<Data?>
        public let threadNodeCapabilities: GenericCharacteristic<UInt16>
        public let threadStatus: GenericCharacteristic<UInt16>

        // MARK: - Optional Characteristics
        public let ccaEnergyDetectThreshold: GenericCharacteristic<Int>?
        public let ccaSignalDetectThreshold: GenericCharacteristic<Int>?
        public let eventRetransmissionMaximum: GenericCharacteristic<UInt8>?
        public let eventTransmissionCounters: GenericCharacteristic<UInt32>?
        public let macRetransmissionMaximum: GenericCharacteristic<UInt8>?
        public let macTransmissionCounters: GenericCharacteristic<Data>?
        public let receiverSensitivity: GenericCharacteristic<Int>?
        public let receivedSignalStrengthIndication: GenericCharacteristic<Int>?
        public let signalToNoiseRatio: GenericCharacteristic<Int>?
        public let threadOpenthreadVersion: GenericCharacteristic<String>?
        public let transmitPower: GenericCharacteristic<Int>?
        public let maximumTransmitPower: GenericCharacteristic<Int>?
    }
}
