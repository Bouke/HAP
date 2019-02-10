extension Accessory {
    open class GarageDoorOpener: Accessory {
        public let garageDoorOpener = Service.GarageDoorOpener()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .garageDoorOpener, services: [garageDoorOpener] + additionalServices)
        }
    }
}

extension Service {
    open class GarageDoorOpener: GarageDoorOpenerBase {

    }
}
