extension Accessory {
    open class LightSensor: Accessory {
        public let lightSensor = Service.LightSensor()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .sensor, services: [lightSensor] + additionalServices)
        }
    }
}

extension Service {
    open class LightSensor: LightSensorBase {
    }
}
