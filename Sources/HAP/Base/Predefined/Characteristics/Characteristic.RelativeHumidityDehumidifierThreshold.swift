import Foundation

public extension AnyCharacteristic {
    static func relativeHumidityDehumidifierThreshold(
        _ value: Float = 0,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Relative Humidity Dehumidifier Threshold",
        format: CharacteristicFormat? = .float,
        unit: CharacteristicUnit? = .percentage,
        maxLength: Int? = nil,
        maxValue: Double? = 100,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.relativeHumidityDehumidifierThreshold(
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
    static func relativeHumidityDehumidifierThreshold(
        _ value: Float = 0,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Relative Humidity Dehumidifier Threshold",
        format: CharacteristicFormat? = .float,
        unit: CharacteristicUnit? = .percentage,
        maxLength: Int? = nil,
        maxValue: Double? = 100,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Float> {
        GenericCharacteristic<Float>(
            type: .relativeHumidityDehumidifierThreshold,
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
