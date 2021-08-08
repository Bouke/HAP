import Foundation

public extension AnyCharacteristic {
    static func currentFanState(
        _ value: Enums.CurrentFanState = .inactive,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Fan State",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 2,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.currentFanState(
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
    static func currentFanState(
        _ value: Enums.CurrentFanState = .inactive,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Fan State",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 2,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Enums.CurrentFanState> {
        GenericCharacteristic<Enums.CurrentFanState>(
            type: .currentFanState,
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
