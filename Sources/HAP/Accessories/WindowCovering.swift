extension Accessory {
    open class WindowCovering: Accessory {
        public let windowCovering = Service.WindowCovering()

        public init(info: Service.Info) {
            super.init(info: info, type: .windowCovering, services: [windowCovering])
        }
    }
}

extension Service {
    open class WindowCovering: Service {
        public let currentPosition = GenericCharacteristic<CurrentPosition>(type: .currentPosition, value: 0, permissions: [.read, .events], unit: .percentage, maxValue: 100, minValue: 0, minStep: 1)
        public let positionState = GenericCharacteristic<PositionState>(type: .positionState, value: .stopped, permissions: [.read, .events])
        public let targetPosition = GenericCharacteristic<TargetPosition>(type: .targetPosition, value: 0, unit: .percentage, maxValue: 100, minValue: 0, minStep: 1)

        public init() {
            super.init(type: .windowCovering, characteristics: [currentPosition, positionState, targetPosition])
        }
    }
}
