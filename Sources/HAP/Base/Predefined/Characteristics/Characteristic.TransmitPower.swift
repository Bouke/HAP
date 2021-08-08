import Foundation

public extension AnyCharacteristic {
    static func transmitPower(
        _ value: Int = 0,
        permissions: [CharacteristicPermission] = [.read],
        description: String? = "Transmit Power",
        format: CharacteristicFormat? = .int,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        minStep: Double? = nil,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.transmitPower(
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
    static func transmitPower(
        _ value: Int = 0,
        permissions: [CharacteristicPermission] = [.read],
        description: String? = "Transmit Power",
        format: CharacteristicFormat? = .int,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        minStep: Double? = nil,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Int> {
        GenericCharacteristic<Int>(
            type: .transmitPower,
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
