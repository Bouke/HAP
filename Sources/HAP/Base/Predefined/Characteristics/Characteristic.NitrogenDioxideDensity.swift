import Foundation

public extension AnyCharacteristic {
    static func nitrogenDioxideDensity(
        _ value: Float = 0,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Nitrogen dioxide Density",
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
            PredefinedCharacteristic.nitrogenDioxideDensity(
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
    static func nitrogenDioxideDensity(
        _ value: Float = 0,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Nitrogen dioxide Density",
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
            type: .nitrogenDioxideDensity,
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
