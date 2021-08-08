import Foundation

public extension AnyCharacteristic {
    static func obstructionDetected(
        _ value: Bool = false,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Obstruction Detected",
        format: CharacteristicFormat? = .bool,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        minStep: Double? = nil,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.obstructionDetected(
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
    static func obstructionDetected(
        _ value: Bool = false,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Obstruction Detected",
        format: CharacteristicFormat? = .bool,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        minStep: Double? = nil,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Bool> {
        GenericCharacteristic<Bool>(
            type: .obstructionDetected,
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
