extension Accessory {
    open class OccupancySensor: Accessory {
        public let occupancySensor = Service.OccupancySensor()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .sensor, services: [occupancySensor] + additionalServices)
        }
    }
}

extension Service {
    open class OccupancySensor: OccupancySensorBase {
    }
}
