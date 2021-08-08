import Foundation

extension Service {
    open class AirQualitySensor: Service {
        // Required Characteristics
        public let currentAirQuality: GenericCharacteristic<Enums.CurrentAirQuality>

        // Optional Characteristics
        public let nitrogenDioxideDensity: GenericCharacteristic<Float>?
        public let ozoneDensity: GenericCharacteristic<Float>?
        public let pm10Density: GenericCharacteristic<Float>?
        public let pm2_5Density: GenericCharacteristic<Float>?
        public let sulphurDioxideDensity: GenericCharacteristic<Float>?
        public let volatileOrganicCompoundDensity: GenericCharacteristic<Float>?
        public let name: GenericCharacteristic<String>?
        public let statusActive: GenericCharacteristic<Bool>?
        public let statusFault: GenericCharacteristic<UInt8>?
        public let statusLowBattery: GenericCharacteristic<Enums.StatusLowBattery>?
        public let statusTampered: GenericCharacteristic<UInt8>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            currentAirQuality = getOrCreateAppend(
                type: .currentAirQuality,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentAirQuality() })
            nitrogenDioxideDensity = get(type: .nitrogenDioxideDensity, characteristics: unwrapped)
            ozoneDensity = get(type: .ozoneDensity, characteristics: unwrapped)
            pm10Density = get(type: .pm10Density, characteristics: unwrapped)
            pm2_5Density = get(type: .pm2_5Density, characteristics: unwrapped)
            sulphurDioxideDensity = get(type: .sulphurDioxideDensity, characteristics: unwrapped)
            volatileOrganicCompoundDensity = get(type: .volatileOrganicCompoundDensity, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            statusActive = get(type: .statusActive, characteristics: unwrapped)
            statusFault = get(type: .statusFault, characteristics: unwrapped)
            statusLowBattery = get(type: .statusLowBattery, characteristics: unwrapped)
            statusTampered = get(type: .statusTampered, characteristics: unwrapped)
            super.init(type: .airQualitySensor, characteristics: unwrapped)
        }
    }
}
