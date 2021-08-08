import Foundation

public extension AnyCharacteristic {
    static func volume(
        _ value: UInt8 = 0,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Volume",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = .percentage,
        maxLength: Int? = nil,
        maxValue: Double? = 100,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.volume(
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
    static func volume(
        _ value: UInt8 = 0,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Volume",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = .percentage,
        maxLength: Int? = nil,
        maxValue: Double? = 100,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<UInt8> {
        GenericCharacteristic<UInt8>(
            type: .volume,
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
