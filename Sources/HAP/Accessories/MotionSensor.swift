//
//  MotionSensor.swift
//
//  Created by Guy Brooker on 24/12/2017.
//


extension Accessory {
    open class MotionSensor: Accessory {
        public let motionSensor = Service.MotionSensor()
        
        public init(info: Service.Info) {
            super.init(info: info, type: .sensor, services: [motionSensor])
        }
    }
}


public typealias MotionDetected = Bool



extension Service {
    open class MotionSensor: Service {
        public let motionDetected = GenericCharacteristic<MotionDetected>(type: .motionDetected,
                                                                          value: false,
                                                                          permissions: [.read, .events])
        
        public init() {
            super.init(type: .motionSensor, characteristics: [motionDetected])
        }
    }
}




