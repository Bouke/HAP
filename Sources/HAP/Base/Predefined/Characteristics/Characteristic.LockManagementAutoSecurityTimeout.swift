import Foundation

public extension AnyCharacteristic {
    static func lockManagementAutoSecurityTimeout(
        _ value: UInt32 = 0,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Lock Management Auto Security Timeout",
        format: CharacteristicFormat? = .uint32,
        unit: CharacteristicUnit? = .seconds,
        maxLength: Int? = nil,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        minStep: Double? = nil,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.lockManagementAutoSecurityTimeout(
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
    static func lockManagementAutoSecurityTimeout(
        _ value: UInt32 = 0,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Lock Management Auto Security Timeout",
        format: CharacteristicFormat? = .uint32,
        unit: CharacteristicUnit? = .seconds,
        maxLength: Int? = nil,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        minStep: Double? = nil,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<UInt32> {
        GenericCharacteristic<UInt32>(
            type: .lockManagementAutoSecurityTimeout,
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
