//
//  OccupancySensor.swift
//
//  Created by Guy Brooker on 24/12/2017.
//


extension Accessory {
    open class OccupancySensor: Accessory {
        public let occupancySensor = Service.OccupancySensor()
        
        public init(info: Service.Info) {
            super.init(info: info, type: .sensor, services: [occupancySensor])
        }
    }
}

public enum OccupancyDetected: Int, CharacteristicValueType {
    case notDetected = 0, detected
}



extension Service {
    open class OccupancySensor: Service {
        public let occupancyDetected = GenericCharacteristic<OccupancyDetected>(type: .occupancyDetected,
                                                                                value: .notDetected,
                                                                                permissions: [.read, .events])
        
        public init() {
            super.init(type: .occupancySensor, characteristics: [occupancyDetected])
        }
    }
}





