import Foundation

public extension AnyCharacteristic {
    static func threadStatus(
        _ value: UInt16 = 0,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Thread Status",
        format: CharacteristicFormat? = .uint16,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 6,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.threadStatus(
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
    static func threadStatus(
        _ value: UInt16 = 0,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Thread Status",
        format: CharacteristicFormat? = .uint16,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 6,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<UInt16> {
        GenericCharacteristic<UInt16>(
            type: .threadStatus,
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
