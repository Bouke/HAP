extension Accessory {
    open class LightSensor: Accessory {
        public let lightSensor = Service.LightSensor()

        public init(info: Service.Info) {
            super.init(info: info, type: .sensor, services: [lightSensor])
        }
    }
}

public typealias CurrentLight = Double

extension Service {
    open class LightSensor: Service {
        public let currentLight = GenericCharacteristic<CurrentLight>(type: .lightLevel, value: 0, permissions: [.read, .events], maxValue: 100000, minValue: 0.0001)

        public init() {
            super.init(type: .lightSensor, characteristics: [currentLight])
        }
    }
}
