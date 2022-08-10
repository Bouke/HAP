import Foundation

public extension AnyCharacteristic {
    static func pm25Density(
        _ value: Float = 0,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "PM2.5 Density",
        format: CharacteristicFormat? = .float,
        unit: CharacteristicUnit? = .microgramsPerMCubed,
        maxLength: Int? = nil,
        maxValue: Double? = 1000,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.pm25Density(
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
    static func pm25Density(
        _ value: Float = 0,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "PM2.5 Density",
        format: CharacteristicFormat? = .float,
        unit: CharacteristicUnit? = .microgramsPerMCubed,
        maxLength: Int? = nil,
        maxValue: Double? = 1000,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Float> {
        GenericCharacteristic<Float>(
            type: .pm25Density,
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
