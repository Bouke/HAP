extension Accessory {
    open class SmokeSensor: Accessory {
        public let smokeSensor = Service.SmokeSensor()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .sensor, services: [smokeSensor] + additionalServices)
        }
    }
}

extension Service {
    open class SmokeSensor: SmokeSensorBase {
    }
}
