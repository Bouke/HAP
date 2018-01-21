extension Accessory {
    open class GarageDoorOpener: Accessory {
        public let garageDoorOpener = Service.GarageDoorOpener()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .garage, services: [garageDoorOpener] + additionalServices)
        }
    }
}

public enum CurrentDoorState: Int, CharacteristicValueType {
    case open = 0, closed, opening, closing, stopped
}

public enum TargetDoorState: Int, CharacteristicValueType {
    case open = 0, closed
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
