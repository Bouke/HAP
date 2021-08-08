import Foundation

public extension AnyCharacteristic {
    static func currentHumidifierDehumidifierState(
        _ value: Enums.CurrentHumidifierDehumidifierState = .inactive,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Humidifier-Dehumidifier State",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 3,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.currentHumidifierDehumidifierState(
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
    static func currentHumidifierDehumidifierState(
        _ value: Enums.CurrentHumidifierDehumidifierState = .inactive,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Humidifier-Dehumidifier State",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 3,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Enums.CurrentHumidifierDehumidifierState> {
        GenericCharacteristic<Enums.CurrentHumidifierDehumidifierState>(
            type: .currentHumidifierDehumidifierState,
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
