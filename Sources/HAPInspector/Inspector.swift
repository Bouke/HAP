// swiftlint:disable force_cast inclusive_language
import Foundation

extension String {
    func lowercasedFirstLetter() -> String {
        prefix(1).lowercased() + dropFirst()
    }

    mutating func lowercasedFirstLetter() {
        self = self.lowercasedFirstLetter()
    }
    func uppercasedFirstLetter() -> String {
        let string = self.replacingOccurrences(of: "`", with: "")
        return string.prefix(1).uppercased() + string.dropFirst()
    }

    mutating func uppercasedFirstLetter() {
        self = self.uppercasedFirstLetter()
    }

    // Make string into a legal swift instance variable name
    func parameterName() -> String {
        self
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .capitalized
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "_")
            .lowercasedFirstLetter()
    }
}

// swiftlint:disable:next type_body_length
public class Inspector {
    struct DefaultType {
        let enumName: String
        let baseType: String
        let characteristic: String
        let values: [(String, Int)]

        init(_ typeName: String, _ baseType: String, _ characteristic: String, _ values: [(String, Int)]) {
            self.enumName = typeName
            self.baseType = baseType
            self.characteristic = characteristic
            self.values = values
        }
    }

    static let defaultTypes: [DefaultType] = [

        DefaultType("ContactSensorState", "UInt8", "contact-state", [
            ("detected", 0),
            ("notDetected", 1)
        ]),

        DefaultType("PositionState", "UInt8", "position.state", [
            ("decreasing", 0),
            ("increasing", 1),
            ("stopped", 2)
        ]),

        DefaultType("CurrentDoorState", "UInt8", "door-state.current", [
            ("open", 0),
            ("closed", 1),
            ("opening", 2),
            ("closing", 3),
            ("stopped", 4)
        ]),

        DefaultType("TargetDoorState", "UInt8", "door-state.target", [
            ("open", 0),
            ("closed", 1)
        ]),

        DefaultType("LockCurrentState", "UInt8", "lock-mechanism.current-state", [
            ("unsecured", 0),
            ("secured", 1),
            ("jammed", 2),
            ("unknown", 3)
        ]),

        DefaultType("LockTargetState", "UInt8", "lock-mechanism.target-state", [
            ("unsecured", 0),
            ("secured", 1)
        ]),

        DefaultType("SmokeDetected", "UInt8", "smoke-detected", [
            ("smokeNotDetected", 0),
            ("smokeDetected", 1)
        ]),

        DefaultType("Active", "UInt8", "active", [
            ("inactive", 0),
            ("active", 1)
        ]),

        DefaultType("SleepDiscoveryMode", "UInt8", "sleep-discovery-mode", [
            ("notDiscoverable", 0),
            ("alwaysDiscoverable", 1)
        ]),

        DefaultType("ClosedCaptions", "UInt8", "closed-captions", [
            ("disabled", 0),
            ("enabled", 1)
        ]),

        DefaultType("TargetMediaState", "UInt8", "media-state.target", [
            ("play", 0),
            ("pause", 1),
            ("stop", 2)
        ]),

        DefaultType("PictureMode", "UInt16", "picture-mode", [
            ("other", 0),
            ("standard", 1),
            ("calibrated", 2),
            ("calibratedDark", 3),
            ("vivid", 4),
            ("game", 5),
            ("computer", 6),
            ("custom", 7)
        ]),

        DefaultType("PowerModeSelection", "UInt8", "power-mode-selection", [
            ("show", 0),
            ("hide", 1)
        ]),

        DefaultType("RemoteKey", "UInt8", "remote-key", [
            ("rewind", 0),
            ("fastForward", 1),
            ("nextTrack", 2),
            ("previousTrack", 3),
            ("arrowUp", 4),
            ("arrowDown", 5),
            ("arrowLeft", 6),
            ("arrowRight", 7),
            ("select", 8),
            ("back", 9),
            ("exit", 10),
            ("playPause", 11),
            ("information", 15)
        ]),

        DefaultType("InputSourceType", "UInt8", "input-source-type", [
            ("other", 0),
            ("homeScreen", 1),
            ("tuner", 2),
            ("hdmi", 3),
            ("compositeVideo", 4),
            ("sVideo", 5),
            ("componentVideo", 6),
            ("dvi", 7),
            ("airplay", 8),
            ("usb", 9),
            ("application", 10)
        ]),

        DefaultType("InputDeviceType", "UInt8", "input-device-type", [
            ("other", 0),
            ("tv", 1),
            ("recording", 2),
            ("tuner", 3),
            ("playback", 4),
            ("audioSystem", 5)
        ]),

        DefaultType("CurrentVisibilityState", "UInt8", "visibility-state.current", [
            ("shown", 0),
            ("hidden", 1),
            ("state2", 2),
            ("state3", 3)
        ]),

        DefaultType("TargetVisibilityState", "UInt8", "visibility-state.target", [
            ("shown", 0),
            ("hidden", 1)
        ]),

        DefaultType("VolumeControlType", "UInt8", "volume-control-type", [
            ("none", 0),
            ("relative", 1),
            ("relativeWithCurrent", 2),
            ("absolute", 3)
        ]),

        DefaultType("VolumeSelector", "UInt8", "volume-selector", [
            ("increment", 0),
            ("decrement", 1)
        ]),

        DefaultType("IsConfigured", "UInt8", "is-configured", [
            ("notConfigured", 0),
            ("configured", 1)
        ]),

        DefaultType("TemperatureDisplayUnits", "UInt8", "temperature.units", [
            ("celcius", 0),
            ("fahrenheit", 1)
        ])

    ]

    struct FileHandlerOutputStream: TextOutputStream {
        private let fileHandle: FileHandle
        let encoding: String.Encoding

        init(_ fileHandle: FileHandle, encoding: String.Encoding = .utf8) {
            self.fileHandle = fileHandle
            self.encoding = encoding
        }

        mutating func write(_ string: String) {
            if let data = string.data(using: encoding) {
                fileHandle.write(data)
            }
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    class func inspect(source plistPath: URL, target outputPath: String) throws {
        // Convert HAP unit names to swift instance variable name
        func unitName(_ name: String) -> String {
            name.lowercased()
                .replacingOccurrences(of: "/", with: " per ")
                .replacingOccurrences(of: "^3", with: " cubed ")
                .parameterName()
        }

        // Convert HAP type to swift type name
        func typeName(_ name: String) -> String {
            let name = name.lowercased()
            if name.first == "u" {
                return name.prefix(2).uppercased() + name.dropFirst(2)
            } else if name == "tlv8" {
                return "Data"
            }
            return name.capitalized
        }

        // Convert HAP accessory category name to swift instance variable name
        func categoryName(_ name: String) -> String {
            let knownConversion = ["Apple TV": "appleTV", "Switch": "`switch`"]
            if let knownName = knownConversion[name] {
                return knownName
            }
            return name.parameterName()
        }

        // Convert HAP service name to swift instance variable name
        func serviceName(_ name: String, uuid: String) -> String {
            if uuid == "000000B7" {
                return "fanV2"
            }
            let knownConversion = ["Accessory Information Service": "info", "Switch": "`switch`"]
            if let knownName = knownConversion[name] {
                return knownName
            }
            return name.parameterName()
        }

        // Convert HAP permission flags into comma seperated swift permission enum values
        func permissions(_ permissions: Int) -> String {
            var list = [String]()
            if (permissions & 2) == 2 {
                list.append(".read")
            }
            if (permissions & 4) == 4 {
                list.append(".write")
            }
            if (permissions & 1) == 1 {
                list.append(".events")
            }
            return list.joined(separator: ", ")
        }

        // Decode plist

        guard let plist = NSDictionary(contentsOf: plistPath),
            let plistDict = plist["PlistDictionary"] as? NSDictionary,
            let assistantDict = plistDict["Assistant"] as? NSDictionary,
            let hapDict = plistDict["HAP"] as? NSDictionary,
            let homekitDict = plistDict["HomeKit"] as? NSDictionary,
            let categories = homekitDict["Categories"] as? [String: NSDictionary],
            let services = hapDict["Services"] as? [String: NSDictionary],
            let characteristics = hapDict["Characteristics"]  as? [String: NSDictionary],
            let characteristicConstants = assistantDict["Characteristics"] as? [String: NSDictionary],
            let units = hapDict["Units"]  as? [String: NSDictionary],
            let blacklist = homekitDict["Blacklist"] as? [String: [String]],
            let blacklistApps = homekitDict["BlacklistFromApplications"] as? [String: [String]],
            let blacklistCharacteristics = blacklist["Characteristics"],
            let blacklistServices = blacklist["Services"],
            let blacklistAppServices = blacklistApps["Services"] else {
                print("Could not read plist")
                return
            }

        var blacklistedServices = blacklistServices
        blacklistedServices.append(contentsOf: blacklistAppServices)

        let blacklistedCharacteristics = blacklistCharacteristics
        // Don't remove characteristics from app blacklist
        //blacklistedCharacteristics.append(contentsOf: blacklistAppCharacteristics)

        print("Writing to \(outputPath)")

        try FileManager.default.createDirectory(atPath: "\(outputPath)/Enums", withIntermediateDirectories: false, attributes: nil)
        try FileManager.default.createDirectory(atPath: "\(outputPath)/Services", withIntermediateDirectories: false, attributes: nil)
        try FileManager.default.createDirectory(atPath: "\(outputPath)/Characteristics", withIntermediateDirectories: false, attributes: nil)

        func writeToFile(atPath path: String, generator: ((String) -> Void) -> Void) throws {
            let url = URL(fileURLWithPath: "\(outputPath)/\(path)")
            FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)

            let fileHandle = try FileHandle(forWritingTo: url)
            var output = FileHandlerOutputStream(fileHandle)

            defer {
                fileHandle.closeFile()
            }

            func write(_ msg: String, terminator: String = "\n") {
                print(msg, terminator: terminator, to: &output)
            }

            generator({ x in write(x) })
        }

        // File Header

        try writeToFile(atPath: "README") { write in
            let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .long
            let today = formatter.string(from: currentDateTime)

            write("""
                The files in this directory have been generated automatically
                from the macOS HomeKit framework definitions. Don't make changes
                to these files directly. Update these files using the `hap-update`
                tool.

                Generated on:              \(today)
                HomeKit framework version: \(plist["Version"] ?? "?")
                macOS:                     \(osVersion)
                """)
        }

        // Categories

        struct CategoryInfo {
            let name: String
            let id: Int
        }

        var categoryInfo = [CategoryInfo]()

        for (_, dict) in categories {
            if let title = dict["DefaultDescription"] as? String,
                let id = dict["Identifier"] as? Int {
                categoryInfo.append(CategoryInfo(name: title, id: id))
            }
        }

        try writeToFile(atPath: "AccessoryType.swift") { write in
            write("""
            public enum AccessoryType: String, Codable {
            """)
            for category in categoryInfo.sorted(by: { $0.id < $1.id }) {
                write("    case \(categoryName(category.name)) = \"\(category.id)\"")
            }
            write("""
            }

            extension AccessoryType: CustomStringConvertible {
                public var description: String {
                    switch self {
            """)
            for category in categoryInfo.sorted(by: { $0.id < $1.id }) {
                write("        case .\(categoryName(category.name)): return \"\(category.name)\"")
            }
            write("""
                    }
                }
            }
            """)
        }

        struct ServiceInfo {
            let name: String
            let title: String
            let paramName: String
            let className: String
            let id: String
            let required: [String]
            let optional: [String]
        }

        var serviceInfo = [ServiceInfo]()

        var whitelistedCharacteristics = Set<String>()

        for (name, dict) in services {
            if let title = dict["DefaultDescription"] as? String,
                let id = dict["ShortUUID"] as? String {
                if !blacklistedServices.contains(name),
                    let serviceCharacteristics = dict["Characteristics"] as? [String: [String]] {

                    let required = serviceCharacteristics["Required"] ?? []
                    let optional = serviceCharacteristics["Optional"] ?? []
                    serviceInfo.append(ServiceInfo(name: name,
                                                   title: title,
                                                   paramName: serviceName(title, uuid: id),
                                                   className: serviceName(title, uuid: id).uppercasedFirstLetter(),
                                                   id: id,
                                                   required: required,
                                                   optional: optional
                    ))

                    whitelistedCharacteristics = whitelistedCharacteristics.union(required)
                    whitelistedCharacteristics = whitelistedCharacteristics.union(optional)

                }
            }
        }

        // Service types

        try writeToFile(atPath: "ServiceType.swift") { write in
            write("""
            public extension ServiceType {
            """)
            for service in serviceInfo.sorted(by: { $0.className < $1.className }) {
                write("    static let \(serviceName(service.title, uuid: service.id)) = ServiceType(0x\(service.id.suffix(4)))")
            }
            write("""
            }

            extension ServiceType: CustomStringConvertible {
                public var description: String {
                    switch self {
            """)
            for service in serviceInfo.sorted(by: { $0.className < $1.className }) {
                if let id = Int(service.id, radix: 16) {
                    _ = String(id, radix: 16, uppercase: true)
                    write("        case .\(serviceName(service.title, uuid: service.id)): return \"\(service.title)\"")
                }
            }
            write("""
                    case let .appleDefined(typeCode):
                        let hex = String(typeCode, radix: 16).uppercased()
                        return "Apple Defined (\\(hex))"
                    case let .custom(uuid):
                        return "\\(uuid)"
                    }
                }
            }
            """)
        }

        // Characteristic types

        struct CharacteristicInfo {
            let hkname: String
            let title: String
            let id: String
            let format: String
            let maxValue: NSNumber?
            let minValue: NSNumber?
            let properties: Int
            let stepValue: NSNumber?
            let units: String?
            var permissions: [CharacteristicInfoPermission] {
                var list = [CharacteristicInfoPermission]()
                if properties & 2 == 2 {
                    list.append(.read)
                }
                if properties & 4 == 4 {
                    list.append(.write)
                }
                if properties & 1 == 1 {
                    list.append(.events)
                }
                return list
            }
            var isReadable: Bool {
                permissions.contains(.read)
            }
        }

        var characteristicInfo = [CharacteristicInfo]()

        var characteristicFormats = Set<String>()

        for (name, dict) in characteristics {
            if let title = dict["DefaultDescription"] as? String,
                let id = dict["ShortUUID"] as? String,
                let format = dict["Format"] as? String {
                if !blacklistedCharacteristics.contains(name) && whitelistedCharacteristics.contains(name) {

                    characteristicInfo.append(
                        CharacteristicInfo(hkname: name,
                                           title: title,
                                           id: id,
                                           format: format,
                                           maxValue: dict["MaxValue"] as? NSNumber,
                                           minValue: dict["MinValue"] as? NSNumber,
                                           properties: dict["Properties"] as? Int ?? Int(dict["Properties"].debugDescription)!,
                                           stepValue: dict["StepValue"] as? NSNumber,
                                           units: dict["Units"] as? String))
                    characteristicFormats.insert(format)

                }
            }
        }

        try writeToFile(atPath: "CharacteristicType.swift") { write in
            write("""
            // swiftlint:disable no_grouping_extension
            public extension CharacteristicType {
            """)

            for characteristic in characteristicInfo.sorted(by: { $0.title < $1.title }) {
                write("    static let \(serviceName(characteristic.title, uuid: characteristic.id)) = CharacteristicType(0x\(characteristic.id.suffix(4)))")
            }
            write("""
            }

            extension CharacteristicType: CustomStringConvertible {
                public var description: String {
                    switch self {
            """)
            for characteristic in characteristicInfo.sorted(by: { $0.title < $1.title }) {
                if let id = Int(characteristic.id, radix: 16) {
                    _ = String(id, radix: 16, uppercase: true)
                    write("        case .\(serviceName(characteristic.title, uuid: characteristic.id)): return \"\(characteristic.title)\"")
                }
            }
            write("""
                    case let .appleDefined(typeCode):
                        let hex = String(typeCode, radix: 16).uppercased()
                        return "Apple Defined (\\(hex))"
                    case let .custom(uuid):
                        return "\\(uuid)"
                    }
                }
            }
            """)
        }

        // Characteristic Formats

        characteristicFormats = characteristicFormats.union(["data", "uint16"])

        try writeToFile(atPath: "CharacteristicFormat.swift") { write in
            write("""
            public enum CharacteristicFormat: String, Codable {
            """)
            for format in characteristicFormats.sorted(by: { $0 < $1 }) {
                write("    case \(format.lowercased())")
            }
            write("}")
        }

        // Characteristic Units

        var unitInfo = [String]()

        for (name, dict) in units {
            if (dict["DefaultDescription"] as? String) != nil {
                unitInfo.append(unitName(name))
            }
        }

        try writeToFile(atPath: "CharacteristicUnit.swift") { write in
            write("""
            public enum CharacteristicUnit: String, Codable {
            """)
            for unit in unitInfo.sorted(by: { $0 < $1 }) {
                write("    case \(unit)")
            }
            write("}")
        }

        // Characteristic enumerated types

        var enumeratedCharacteristics = Set<String>()
        var defaultEnumCase = [String: String]()

        func determineEnumerationCases(_ newValues: NSDictionary) -> NSDictionary? {
            var values = newValues

            // Check if keys are digits

            let numberedKeys = values.allKeys.compactMap({ ($0 as? NSNumber)?.intValue ?? Int($0 as? String ?? "x") })
            if numberedKeys.count == values.count {

                // Check if vals are also all digits
                let numberedValues = values.allValues.compactMap({ ($0 as? NSNumber)?.intValue ?? Int($0 as? String ?? "x") })

                if numberedValues.count == values.count {
                    return nil
                }

                // Swap keys and values

                let keys = values.allKeys
                let vals = values.allValues
                values = NSDictionary(objects: keys, forKeys: vals as! [NSCopying])
            }

            return values
        }

        try writeToFile(atPath: "Enums.swift") { write in
            write("public class Enums { }")
        }

        func writeEnumeration(enumName: String, type: String, values: NSDictionary, max: NSNumber?) throws {
            try writeToFile(atPath: "Enums/Enums.\(enumName).swift") { write in
                write("public extension Enums {")
                write("    enum \(enumName): \(type), CharacteristicValueType {")
                let cases = values.sorted(by: {
                    if let number = $0.value as? NSNumber {
                        return number.intValue < ($1.value as! NSNumber).intValue
                    } else if let string = $0.value as? String {
                        return string < ($1.value as! String)
                    }
                    return false
                }).filter({
                    guard let max = max else {
                        return true
                    }
                    let val: NSNumber
                    if let number = $0.value as? NSNumber {
                        val = number
                    } else if let string = $0.value as? String,
                        let num = NumberFormatter().number(from: string) {
                        val = num
                    } else {
                        return true
                    }
                    return !(max.compare(val) == .orderedAscending)
                })
                for enumCase in cases {
                    if let name = (enumCase.key as? String) {
                        write("        case \(name.parameterName()) = \(enumCase.value)")
                    }
                }
                write("    }")
                write("}")
            }
        }

        var enums = [(enumName: String, type: String, newValues: NSDictionary, info: CharacteristicInfo)]()

        for (_, dict) in characteristicConstants {
            let rName = dict["Read"] as? String
            let wName = dict["Write"] as? String
            let rwName = dict["ReadWrite"] as? String
            let wValues = dict["Values"] as? NSDictionary
            let rValues = dict["OutValues"] as? NSDictionary

            if rName != nil && wName != nil && rValues != nil && wValues != nil {
                print("r:\(rName!) w:\(wName!)")
            }

            if let rName = rName, let values = rValues,
                let info = characteristicInfo.first(where: { $0.hkname == rName }) {

                let enumName = info.title.parameterName().uppercasedFirstLetter()
                let type = typeName(info.format)

                enums.append((enumName: enumName, type: type, newValues: values, info: info))
            } else if let rName = rName, let values = wValues,
                let info = characteristicInfo.first(where: { $0.hkname == rName }) {

                let enumName = info.title.parameterName().uppercasedFirstLetter()
                let type = typeName(info.format)

                enums.append((enumName: enumName, type: type, newValues: values, info: info))
            }

            if let wName = wName, let values = wValues,
                let info = characteristicInfo.first(where: { $0.hkname == wName }) {

                let enumName = info.title.parameterName().uppercasedFirstLetter()
                let type = typeName(info.format)

                enums.append((enumName: enumName, type: type, newValues: values, info: info))
            }

            if let rwName = rwName, let values = wValues,
                let info = characteristicInfo.first(where: { $0.hkname == rwName }) {

                let enumName = info.title.parameterName().uppercasedFirstLetter()
                let type = typeName(info.format)

                enums.append((enumName: enumName, type: type, newValues: values, info: info))
            }

        }

        // Add any default enums which are not defined in the HAP config
        for defaultType in Inspector.defaultTypes {
            if enums.first(where: { $0.info.hkname == defaultType.characteristic }) != nil {
                // Already defined
            } else if let info = characteristicInfo.first(where: { $0.hkname == defaultType.characteristic }) {
                print("Using predefined enum for '\(defaultType.enumName)'")
                let valuedict = NSMutableDictionary()
                for value in defaultType.values {
                    valuedict[value.0] = value.1
                }
                enums.append((enumName: defaultType.enumName, type: defaultType.baseType, newValues: valuedict, info: info))
            }
        }

        for (enumName, type, values, info) in enums.sorted(by: { $0.enumName < $1.enumName }) {
            if let enumCases = determineEnumerationCases(values) {
                try writeEnumeration(enumName: enumName, type: type, values: enumCases, max: info.maxValue)
                enumeratedCharacteristics.insert(info.hkname)
                defaultEnumCase[info.hkname] = (enumCases.allKeys[0] as! String).parameterName()
            } else if let defaultType = Inspector.defaultTypes.first(where: { $0.characteristic == info.hkname }) {
                // The HAP config definition couldn't be written, likely because both key and values are digits
                // Fallback to a default definition if it exists
                print("Use predefined enum cases for '\(enumName)'")
                let valuedict = NSMutableDictionary()
                for value in defaultType.values {
                    valuedict[value.0] = value.1
                }
                try writeEnumeration(enumName: defaultType.enumName, type: defaultType.baseType, values: valuedict, max: info.maxValue)
                enumeratedCharacteristics.insert(info.hkname)
                defaultEnumCase[info.hkname] = defaultType.values[0].0.parameterName()
            } else {
                print("Could not determine enum cases for '\(enumName)'")
            }
        }

        // Service classes

        func valueType(_ characteristic: CharacteristicInfo) -> String {
            let name = characteristic.title.parameterName()
            let enumType = enumeratedCharacteristics.contains(characteristic.hkname) ?
                "Enums.\(name.uppercasedFirstLetter())" :
                typeName(characteristic.format)
            return enumType + (characteristic.isReadable ? "" : "?")
        }

        for service in serviceInfo.sorted(by: { $0.className < $1.className }) {
            try writeToFile(atPath: "Services/Service.\(service.className).swift") { write in
                func writeCharacteristicProperty(info: CharacteristicInfo, isOptional: Bool) {
                    let name = info.title.parameterName()
                    write("        public let \(name): GenericCharacteristic<\(valueType(info))>\(isOptional ? "?" : "")")
                }

                write("""
                import Foundation

                extension Service {
                """)
                write("    open class \(service.className): Service {")

                var requiredCharacteristicPropertyNames = [String]()

                write("        // Required Characteristics")
                for characteristic in service.required {
                    if let info = characteristicInfo.first(where: { $0.hkname == characteristic }) {
                        writeCharacteristicProperty(info: info, isOptional: false)
                        requiredCharacteristicPropertyNames.append(info.title.parameterName())
                    }
                }
                write("\n        // Optional Characteristics")
                for characteristic in service.optional {
                    if let info = characteristicInfo.first(where: { $0.hkname == characteristic }) {
                        writeCharacteristicProperty(info: info, isOptional: true)
                    }
                }

                write("""

                            public init(characteristics: [AnyCharacteristic] = []) {
                                var unwrapped = characteristics.map { $0.wrapped }
                    """)

                for characteristic in service.required {
                    if let info = characteristicInfo.first(where: { $0.hkname == characteristic }) {
                        let name = info.title.parameterName()
                        let characteristiceType = ".\(serviceName(info.title, uuid: info.id))"
                        write("""
                                        \(name) = getOrCreateAppend(
                                            type: \(characteristiceType),
                                            characteristics: &unwrapped,
                                            generator: { PredefinedCharacteristic.\(serviceName(info.title, uuid: info.id))() })
                            """)
                    }
                }

                for characteristic in service.optional {
                    if let info = characteristicInfo.first(where: { $0.hkname == characteristic }) {
                        let name = info.title.parameterName()
                        let characteristiceType = ".\(serviceName(info.title, uuid: info.id))"
                        write("""
                                        \(name) = get(type: \(characteristiceType), characteristics: unwrapped)
                            """)
                    }
                }

                write("""
                                super.init(type: .\(serviceName(service.title, uuid: service.id)), characteristics: unwrapped)
                            }
                        }
                    """)
                write("}")
            }
        }

        func defaultValue(_ characteristic: CharacteristicInfo) -> String {
            if characteristic.isReadable {
                if enumeratedCharacteristics.contains(characteristic.hkname) {
                    guard let defaultCase = defaultEnumCase[characteristic.hkname] else {
                        preconditionFailure("No default enum case for enum \(characteristic.hkname)")
                    }
                    return "." + defaultCase
                } else {
                    switch valueType(characteristic) {
                    case "Bool": return "false"
                    case "Data": return "Data()"
                    case "String": return "\"\""
                    case "Float", "Int", "UInt8", "UInt16", "UInt32": return characteristic.minValue?.stringValue ?? "0"
                    default: preconditionFailure("No default value for value type \(valueType(characteristic))")
                    }
                }
            } else {
                return "nil"
            }
        }

        try writeToFile(atPath: "PredefinedCharacteristic.swift") { write in
            write("public class PredefinedCharacteristic { }")
        }

        for characteristic in characteristicInfo.sorted(by: { $0.title < $1.title }) {
            let name = serviceName(characteristic.title, uuid: characteristic.id)

            try writeToFile(atPath: "Characteristics/Characteristic.\(name.uppercasedFirstLetter()).swift") { write in
                func writeFactoryArgumentsWithDefaults() {
                    write("        _ value: \(valueType(characteristic)) = \(defaultValue(characteristic)),")
                    write("        permissions: [CharacteristicPermission] = \(characteristic.permissions.arrayLiteral),")
                    write("        description: String? = \"\(characteristic.title)\",")
                    write("        format: CharacteristicFormat? = .\(characteristic.format),")
                    write("        unit: CharacteristicUnit? = \(characteristic.units != nil ? ".\(unitName(characteristic.units!))" : "nil"),")
                    write("        maxLength: Int? = nil,")
                    write("        maxValue: Double? = \(characteristic.maxValue?.stringValue ?? "nil"),")
                    write("        minValue: Double? = \(characteristic.minValue?.stringValue ?? "nil"),")
                    write("        minStep: Double? = \(characteristic.stepValue?.stringValue ?? "nil"),")
                    write("        validValues: [Double] = [],")
                    write("        validValuesRange: Range<Double>? = nil")
                }
                write("import Foundation")
                write("")
                write("public extension AnyCharacteristic {")
                write("    static func \(name)(")
                writeFactoryArgumentsWithDefaults()
                write("    ) -> AnyCharacteristic {")
                write("        AnyCharacteristic(")
                write("            PredefinedCharacteristic.\(name)(")
                write("            value,")
                write("            permissions: permissions,")
                write("            description: description,")
                write("            format: format,")
                write("            unit: unit,")
                write("            maxLength: maxLength,")
                write("            maxValue: maxValue,")
                write("            minValue: minValue,")
                write("            minStep: minStep,")
                write("            validValues: validValues,")
                write("            validValuesRange: validValuesRange) as Characteristic)")
                write("    }")
                write("}")
                write("")
                write("public extension PredefinedCharacteristic {")
                write("    static func \(name)(")
                writeFactoryArgumentsWithDefaults()
                write("    ) -> GenericCharacteristic<\(valueType(characteristic))> {")
                write("        GenericCharacteristic<\(valueType(characteristic))>(")
                write("            type: .\(name),")
                write("            value: value,")
                write("            permissions: permissions,")
                write("            description: description,")
                write("            format: format,")
                write("            unit: unit,")
                write("            maxLength: maxLength,")
                write("            maxValue: maxValue,")
                write("            minValue: minValue,")
                write("            minStep: minStep,")
                write("            validValues: validValues,")
                write("            validValuesRange: validValuesRange)")
                write("    }")
                write("}")
            }
        }
    }
}

enum CharacteristicInfoPermission: String {
    case read
    case write
    case events
}

extension Array where Element == CharacteristicInfoPermission {
    var arrayLiteral: String {
        "[" + self.map { ".\($0)" }.joined(separator: ", ") + "]"
    }
}
