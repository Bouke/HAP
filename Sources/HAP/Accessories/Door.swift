extension Accessory {
    open class Door: Accessory {
        public let door = Service.Door()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .door, services: [door] + additionalServices)
        }
    }
}

public typealias CurrentPosition = Int

public enum PositionState: Int, CharacteristicValueType {
    case decreasing = 0
    case increasing = 1
    case stopped = 2
}

public typealias TargetPosition = Int

extension Service {
    open class Door: DoorBase {
    }
}
