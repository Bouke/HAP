extension Accessory {
    public class Door: Accessory {
        public let door = Service.Door()
        
        public init(aid: Int) {
            super.init(aid: aid, type: .door, services: [door])
        }
    }
}

public enum PositionState: Int, NSObjectConvertible {
    case decreasing = 0, increasing, stopped
}

extension Service {
    public class Door: Service {
        public let currentPosition = GenericCharacteristic<Int>(type: .currentPosition, permissions: [.read, .events])
        public let positionState = GenericCharacteristic<PositionState>(type: .positionState, permissions: [.read, .events])
        public let targetPosition = GenericCharacteristic<Int>(type: .targetPosition)
        
        public init() {
            super.init(type: .door, characteristics: [currentPosition, positionState, targetPosition])
        }
    }
}
