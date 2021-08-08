import Foundation

public extension AnyCharacteristic {
    static func currentHeaterCoolerState(
        _ value: Enums.CurrentHeaterCoolerState = .heating,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Heater-Cooler State",
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
            PredefinedCharacteristic.currentHeaterCoolerState(
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
    static func currentHeaterCoolerState(
        _ value: Enums.CurrentHeaterCoolerState = .heating,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Heater-Cooler State",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 3,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Enums.CurrentHeaterCoolerState> {
        GenericCharacteristic<Enums.CurrentHeaterCoolerState>(
            type: .currentHeaterCoolerState,
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
