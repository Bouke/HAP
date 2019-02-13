extension Accessory {
    open class Hygrometer: Accessory {
        public let humiditySensor = Service.HumiditySensor()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .sensor, services: [humiditySensor] + additionalServices)
        }
    }
}

extension Service {
    open class HumiditySensor: HumiditySensorBase {
    }
}
