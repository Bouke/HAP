extension Accessory {
    open class Hygrometer: Accessory {
        public let humiditySensor = Service.HumiditySensor()

        public init(info: Service.Info) {
            super.init(info: info, type: .sensor, services: [humiditySensor])
        }
    }
}

public typealias CurrentRelativeHumidity = Double

extension Service {
    open class HumiditySensor: Service {
        public let currentRelativeHumidity = GenericCharacteristic<CurrentRelativeHumidity>(type: .currentHumidity, value: 0, permissions: [.read, .events], maxValue: 100, minValue: 0)

        public init() {
            super.init(type: .humiditySensor, characteristics: [currentRelativeHumidity])
        }
    }
}
