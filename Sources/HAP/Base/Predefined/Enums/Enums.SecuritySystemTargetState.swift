public extension Enums {
    enum SecuritySystemTargetState: UInt8, CharacteristicValueType {
        case stayArm = 0
        case awayArm = 1
        case nightArm = 2
        case disarm = 3
    }
}
