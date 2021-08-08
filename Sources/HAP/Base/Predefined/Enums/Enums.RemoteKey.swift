public extension Enums {
    enum RemoteKey: UInt8, CharacteristicValueType {
        case rewind = 0
        case fastforward = 1
        case nexttrack = 2
        case previoustrack = 3
        case arrowup = 4
        case arrowdown = 5
        case arrowleft = 6
        case arrowright = 7
        case select = 8
        case back = 9
        case exit = 10
        case playpause = 11
        case information = 15
    }
}
