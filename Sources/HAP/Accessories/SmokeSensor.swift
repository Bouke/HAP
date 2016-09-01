//extension Accessory {
//    public class SmokeSensor: Accessory {
//        public let smokeSensor = Service.SmokeSensor()
//        
//        public init(aid: Int) {
//            super.init(aid: aid, type: .smokeSensor, services: [smokeSensor])
//        }
//    }
//}

public enum SmokeDetected: Int, NSObjectConvertible {
    case smokeNotDetected = 0, smokeDetected
}

extension Service {
    open class SmokeSensor: Service {
        public let smokeDetected = GenericCharacteristic<SmokeDetected>(type: .currentPosition, permissions: [.read, .events])
        
        public init() {
            super.init(type: .smokeSensor, characteristics: [smokeDetected])
        }
    }
}
