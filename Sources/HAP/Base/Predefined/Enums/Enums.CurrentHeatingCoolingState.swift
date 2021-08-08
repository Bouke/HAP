public extension Enums {
    enum CurrentHeatingCoolingState: UInt8, CharacteristicValueType {
        case off = 0
        case heat = 1
        case cool = 2
    }
}
