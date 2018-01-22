extension Accessory {
    open class MotionSensor: Accessory {
        public let motionSensor = Service.MotionSensor()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .sensor, services: [motionSensor] + additionalServices)
        }
    }
}

public typealias MotionDetected = Bool

extension Service {
    open class MotionSensor: Service {
        public let motionDetected = GenericCharacteristic<MotionDetected>(
            type: .motionDetected,
            value: false,
            permissions: [.read, .events])

        public init() {
            super.init(type: .motionSensor, characteristics: [motionDetected])
        }
    }
}
