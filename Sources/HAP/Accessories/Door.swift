extension Accessory {
    open class Door: Accessory {
        public let door = Service.Door()

        public init(info: Service.Info) {
            super.init(info: info, type: .door, services: [door])
        }
    }
}

public typealias CurrentPosition = Int

public enum PositionState: Int, CharacteristicValueType {
    case decreasing = 0, increasing, stopped
}

public typealias TargetPosition = Int

extension Service {
    open class Door: Service {
        public let currentPosition = GenericCharacteristic<CurrentPosition>(type: .currentPosition, value: 0, permissions: [.read, .events], unit: .percentage, maxValue: 100, minValue: 0, minStep: 1)
        public let positionState = GenericCharacteristic<PositionState>(type: .positionState, value: .stopped, permissions: [.read, .events])
        public let targetPosition = GenericCharacteristic<TargetPosition>(type: .targetPosition, value: 0, unit: .percentage, maxValue: 100, minValue: 0, minStep: 1)

        public init() {
            super.init(type: .door, characteristics: [currentPosition, positionState, targetPosition])
        }
    }
}
