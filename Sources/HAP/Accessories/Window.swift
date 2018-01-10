extension Accessory {
    open class Window: Accessory {
        public let window = Service.Window()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .window, services: [window] + additionalServices)
        }
    }
}

extension Service {
    open class Window: Service {
        public let currentPosition = GenericCharacteristic<CurrentPosition>(type: .currentPosition, value: 0, permissions: [.read, .events], unit: .percentage, maxValue: 100, minValue: 0, minStep: 1)
        public let positionState = GenericCharacteristic<PositionState>(type: .positionState, value: .stopped, permissions: [.read, .events])
        public let targetPosition = GenericCharacteristic<TargetPosition>(type: .targetPosition, value: 0, unit: .percentage, maxValue: 100, minValue: 0, minStep: 1)

        public init() {
            super.init(type: .window, characteristics: [currentPosition, positionState, targetPosition])
        }
    }
}
