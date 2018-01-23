extension Accessory {
    open class GarageDoorOpener: Accessory {
        public let garageDoorOpener = Service.GarageDoorOpener()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .garage, services: [garageDoorOpener] + additionalServices)
        }
    }
}

public enum CurrentDoorState: Int, CharacteristicValueType {
    case open = 0
    case closed = 1
    case opening = 2
    case closing = 3
    case stopped = 4
}

public enum TargetDoorState: Int, CharacteristicValueType {
    case open = 0
    case closed = 1
}

public typealias ObstructionDetected = Bool

extension Service {
    open class GarageDoorOpener: Service {
        public let currentDoorState = GenericCharacteristic<CurrentDoorState>(
            type: .currentDoorState,
            value: .closed,
            permissions: [.read, .events])
        public let targetDoorState = GenericCharacteristic<TargetDoorState>(
            type: .targetDoorState,
            value: .closed)
        public let obstructionDetected = GenericCharacteristic<ObstructionDetected>(
            type: .obstructionDetected,
            value: false,
            permissions: [.read, .events])

        public init() {
            super.init(type: .garageDoorOpener,
                       characteristics: [currentDoorState,
                                         targetDoorState,
                                         obstructionDetected])
        }
    }
}
