public extension Enums {
    enum VolumeControlType: UInt8, CharacteristicValueType {
        case none = 0
        case relative = 1
        case relativewithcurrent = 2
        case absolute = 3
    }
}
