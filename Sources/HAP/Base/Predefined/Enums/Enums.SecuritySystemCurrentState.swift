public extension Enums {
    enum SecuritySystemCurrentState: UInt8, CharacteristicValueType {
        case stayArm = 0
        case awayArm = 1
        case nightArm = 2
        case disarm = 3
        case alarmTriggered = 4
    }
}
