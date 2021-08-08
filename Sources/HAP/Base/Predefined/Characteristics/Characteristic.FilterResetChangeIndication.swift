import Foundation

public extension AnyCharacteristic {
    static func filterResetChangeIndication(
        _ value: UInt8? = nil,
        permissions: [CharacteristicPermission] = [.write],
        description: String? = "Filter Reset Change Indication",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 1,
        minValue: Double? = 1,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.filterResetChangeIndication(
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
    static func filterResetChangeIndication(
        _ value: UInt8? = nil,
        permissions: [CharacteristicPermission] = [.write],
        description: String? = "Filter Reset Change Indication",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 1,
        minValue: Double? = 1,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<UInt8?> {
        GenericCharacteristic<UInt8?>(
            type: .filterResetChangeIndication,
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
