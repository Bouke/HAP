public extension Enums {
    enum CurrentSlatState: UInt8, CharacteristicValueType {
        case inactive = 0
        case fixed = 1
        case swinging = 2
        case jammed = 3
    }
}
