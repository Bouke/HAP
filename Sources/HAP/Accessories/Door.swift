extension Accessory {
    public class Door: Accessory {
        public let door = Service.Door()
        
        public init(info: Service.Info) {
            super.init(info: info, type: .door, services: [door])
        }
    }
}

public typealias CurrentPosition = Int

public enum PositionState: Int, NSObjectConvertible {
    case decreasing = 0, increasing, stopped
}

public typealias TargetPosition = Int

extension Service {
    public class Door: Service {
        public let currentPosition = GenericCharacteristic<CurrentPosition>(type: .currentPosition, permissions: [.read, .events])
        public let positionState = GenericCharacteristic<PositionState>(type: .positionState, permissions: [.read, .events])
        public let targetPosition = GenericCharacteristic<TargetPosition>(type: .targetPosition)
        
        public init() {
            super.init(type: .door, characteristics: [currentPosition, positionState, targetPosition])
        }
    }
}
