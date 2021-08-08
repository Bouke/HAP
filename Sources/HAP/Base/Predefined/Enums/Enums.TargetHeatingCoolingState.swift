public extension Enums {
    enum TargetHeatingCoolingState: UInt8, CharacteristicValueType {
        case off = 0
        case heat = 1
        case cool = 2
        case auto = 3
    }
}
