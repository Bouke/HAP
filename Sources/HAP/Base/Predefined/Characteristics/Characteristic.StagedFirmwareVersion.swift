import Foundation

public extension AnyCharacteristic {
    static func stagedFirmwareVersion(
        _ value: String = "",
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Staged Firmware Version",
        format: CharacteristicFormat? = .string,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        minStep: Double? = nil,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.stagedFirmwareVersion(
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
    static func stagedFirmwareVersion(
        _ value: String = "",
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Staged Firmware Version",
        format: CharacteristicFormat? = .string,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        minStep: Double? = nil,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<String> {
        GenericCharacteristic<String>(
            type: .stagedFirmwareVersion,
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
