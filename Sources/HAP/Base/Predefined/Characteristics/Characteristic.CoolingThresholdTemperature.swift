import Foundation

public extension AnyCharacteristic {
    static func coolingThresholdTemperature(
        _ value: Float = 10,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Cooling Threshold Temperature",
        format: CharacteristicFormat? = .float,
        unit: CharacteristicUnit? = .celsius,
        maxLength: Int? = nil,
        maxValue: Double? = 35,
        minValue: Double? = 10,
        minStep: Double? = 0.1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.coolingThresholdTemperature(
            value,
            permissions: permissions,
            description: description,
            format: format,
            unit: unit,
            maxLength: maxLength,
            maxValue: maxValue,
            minValue: minValue,
            minStep: minStep,
            validValues: validValues,
            validValuesRange: validValuesRange) as Characteristic)
    }
}

public extension PredefinedCharacteristic {
    static func coolingThresholdTemperature(
        _ value: Float = 10,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Cooling Threshold Temperature",
        format: CharacteristicFormat? = .float,
        unit: CharacteristicUnit? = .celsius,
        maxLength: Int? = nil,
        maxValue: Double? = 35,
        minValue: Double? = 10,
        minStep: Double? = 0.1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Float> {
        GenericCharacteristic<Float>(
            type: .coolingThresholdTemperature,
            value: value,
            permissions: permissions,
            description: description,
            format: format,
            unit: unit,
            maxLength: maxLength,
            maxValue: maxValue,
            minValue: minValue,
            minStep: minStep,
            validValues: validValues,
            validValuesRange: validValuesRange)
    }
}
