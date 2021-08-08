public extension Enums {
    enum LockCurrentState: UInt8, CharacteristicValueType {
        case unsecured = 0
        case secured = 1
        case jammed = 2
        case unknown = 3
    }
}
