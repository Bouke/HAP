extension Accessory {
    open class MotionSensor: Accessory {
        public let motionSensor = Service.MotionSensor()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .sensor, services: [motionSensor] + additionalServices)
        }
    }
}

extension Service {
    open class MotionSensor: MotionSensorBase {
    }
}
