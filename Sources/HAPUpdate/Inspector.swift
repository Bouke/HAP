import Foundation

extension String {
    func lowercasedFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }

    mutating func lowercasedFirstLetter() {
        self = self.lowercasedFirstLetter()
    }
    func uppercasedFirstLetter() -> String {
        let s = self.replacingOccurrences(of: "`", with: "")
        return s.prefix(1).uppercased() + s.dropFirst()
    }

    mutating func uppercasedFirstLetter() {
        self = self.uppercasedFirstLetter()
    }

    // Make string into a legal swift instance variable name
    func parameterName() -> String {
        return self
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .capitalized
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "_")
            .lowercasedFirstLetter()
    }
}

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
            ("notDetected", 1),
            ]),

        DefaultType("PositionState", "UInt8", "position.state", [
            ("decreasing", 0),
            ("increasing", 1),
            ("stopped", 2),
            ]),

        DefaultType("CurrentDoorState", "UInt8", "door-state.current", [
            ("open", 0),
            ("closed", 1),
            ("opening", 2),
            ("closing", 3),
            ("stopped", 4),
            ]),

        DefaultType("TargetDoorState", "UInt8", "door-state.target", [
            ("open", 0),
            ("closed", 1),
            ]),

        DefaultType("LockCurrentState", "UInt8", "lock-mechanism.current-state", [
            ("unsecured", 0),
            ("secured", 1),
            ("jammed", 2),
            ("unknown", 3),
            ]),

        DefaultType("LockTargetState", "UInt8", "lock-mechanism.target-state", [
            ("unsecured", 0),
            ("secured", 1),
            ]),

        DefaultType("SmokeDetected", "UInt8", "smoke-detected", [
            ("smokeNotDetected", 0),
            ("smokeDetected", 1),
            ]),

        DefaultType("Active", "UInt8", "active", [
            ("inactive", 0),
            ("active", 1),
            ]),

        DefaultType("SleepDiscoveryMode", "UInt8", "sleep-discovery-mode", [
            ("notDiscoverable", 0),
            ("alwaysDiscoverable", 1),
            ]),

        DefaultType("ClosedCaptions", "UInt8", "closed-captions", [
            ("disabled", 0),
            ("enabled", 1),
            ]),

        DefaultType("TargetMediaState", "UInt8", "media-state.target", [
            ("play", 0),
            ("pause", 1),
            ("stop", 2),
            ]),

        DefaultType("PictureMode", "UInt16", "picture-mode", [
            ("other", 0),
            ("standard", 1),
            ("calibrated", 2),
            ("calibratedDark", 3),
            ("vivid", 4),
            ("game", 5),
            ("computer", 6),
            ("custom", 7),
            ]),

        DefaultType("PowerModeSelection", "UInt8", "power-mode-selection", [
            ("show", 0),
            ("hide", 1),
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
            ("information", 15),
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
            ("application", 10),
            ]),

        DefaultType("InputDeviceType", "UInt8", "input-device-type", [
            ("other", 0),
            ("tv", 1),
            ("recording", 2),
            ("tuner", 3),
            ("playback", 4),
            ("audioSystem", 5),
            ]),

        DefaultType("CurrentVisibilityState", "UInt8", "visibility-state.current", [
            ("shown", 0),
            ("hidden", 1),
            ]),

        DefaultType("TargetVisibilityState", "UInt8", "visibility-state.target", [
            ("shown", 0),
            ("hidden", 1),
            ]),

        DefaultType("VolumeControlType", "UInt8", "volume-control-type", [
            ("none", 0),
            ("relative", 1),
            ("relativeWithCurrent", 2),
            ("absolute", 3),
            ]),

        DefaultType("VolumeSelector", "UInt8", "volume-selector", [
            ("increment", 0),
            ("decrement", 1),
            ]),

        DefaultType("IsConfigured", "UInt8", "is-configured", [
            ("notConfigured", 0),
            ("configured", 1),
            ]),

        DefaultType("TemperatureDisplayUnits", "UInt8", "temperature.units", [
            ("celcius", 0),
            ("fahrenheit", 1),
            ]),

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

    static let outFile = "Generated.swift"

    class func inspect(source plistPath: URL, target outputPath: String) throws {
        // Convert HAP unit names to swift instance variable name
        func unitName(_ name: String) -> String {
            return name.lowercased()
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
            let knownConversion = ["Apple TV":"appleTV", "Switch":"`switch`"]
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
            let knownConversion = ["Accessory Information Service":"info", "Switch":"`switch`"]
            if let knownName = knownConversion[name] {
                return knownName
            }
            return name.parameterName()
        }

        // Convert HAP permission flags into comma seperated swift permission enum values
        func permissions(_ permissions: Int) -> String {
            var list = [String]()
            if permissions & 2 != 0 {
                list.append(".read")
            }
            if permissions & 4 != 0 {
                list.append(".write")
            }
            if permissions & 1 != 0 {
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
            let categories = homekitDict["Categories"] as? [String:NSDictionary],
            let services = hapDict["Services"] as? [String:NSDictionary],
            let characteristics = hapDict["Characteristics"]  as? [String:NSDictionary],
            let characteristicConstants = assistantDict["Characteristics"] as? [String:NSDictionary],
            let units = hapDict["Units"]  as? [String:NSDictionary],
            let blacklist = homekitDict["Blacklist"] as? [String:[String]],
            let blacklistApps = homekitDict["BlacklistFromApplications"] as? [String:[String]],
            let blacklistCharacteristics = blacklist["Characteristics"],
            let blacklistAppCharacteristics = blacklistApps["Characteristics"],
            let blacklistServices = blacklist["Services"],
            let blacklistAppServices = blacklistApps["Services"] else {
                print("Could not read plist")
                return
            }

        var blacklistedServices = blacklistServices
        blacklistedServices.append(contentsOf: blacklistAppServices)

        var blacklistedCharacteristics = blacklistCharacteristics
        // Don't remove characteristics from app blacklist
        //blacklistedCharacteristics.append(contentsOf: blacklistAppCharacteristics)


        print("Writing to \(outputPath)")

        let url = URL(fileURLWithPath: outputPath)
        FileManager.default.createFile(atPath: outputPath, contents: nil, attributes: nil)

        let fileHandle = try FileHandle(forWritingTo: url)
        var output = FileHandlerOutputStream(fileHandle)

        defer {
            fileHandle.closeFile()
            print("Done")
        }

        func write(_ msg: String, terminator: String = "\n") {
            print(msg, terminator: terminator, to: &output)
        }

        // File Header

        let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        let today = formatter.string(from: currentDateTime)

        write("""
            // This file has been generated automatically from macOS HAP definitions.
            // Don't make changes to this file, but regenerate using `hap-update` instead.
            //
            //  macOS: \(osVersion)
            //  date: \(today)
            //  HAP Version: \(plist["Version"] ?? "?")

            import Foundation

            """)

        // Categories

        write("""
        //
        // HAP Accessory Categories
        //
        """)

        struct CategoryInfo {
            let name: String
            let id: Int
        }

        var categoryInfo = [CategoryInfo]()

        for (name, dict) in categories {
            if let title = dict["DefaultDescription"] as? String,
                let id = dict["Identifier"] as? Int {
                categoryInfo.append(CategoryInfo(name: title, id: id))
            }
        }

        write("""

        public enum AccessoryType: String, Codable {
        """)
        for c in categoryInfo.sorted(by: { $0.id < $1.id } ) {
            write("\tcase \(categoryName(c.name)) = \"\(c.id)\"")
        }
        write("}")

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
                    let serviceCharacteristics = dict["Characteristics"] as? [String:[String]] {

                    let required = serviceCharacteristics["Required"] ?? []
                    let optional = serviceCharacteristics["Optional"] ?? []
                    serviceInfo.append(ServiceInfo(name: name,
                                                    title: title,
                                                    paramName: serviceName(title, uuid: id),
                                                    className: serviceName(title, uuid: id).uppercasedFirstLetter(),
                                                    id: id,
                                                    required: required,
                                                    optional:optional
                    ))

                    whitelistedCharacteristics = whitelistedCharacteristics.union(required)
                    whitelistedCharacteristics = whitelistedCharacteristics.union(optional)

                }
            }
        }

        // Service types

        write("""

        //
        // HAP Service Types
        //
        """)

        write("""

        public extension ServiceType {
        """)
        for service in serviceInfo.sorted(by: { $0.className < $1.className } ) {
            write("\tstatic let \(serviceName(service.title, uuid: service.id)) = ServiceType(0x\(service.id.suffix(4)))")
        }
        write("}")

        // Characteristic types

        write("""

        //
        // HAP Characteristic Types
        //
        """)

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
        }

        var characteristicInfo = [CharacteristicInfo]()

        var characteristicFormats = Set<String>()

        for (name, dict) in characteristics {
            if let title = dict["DefaultDescription"] as? String,
                let id = dict["ShortUUID"] as? String,
                let format = dict["Format"] as? String {
                if !blacklistedCharacteristics.contains(name) && whitelistedCharacteristics.contains(name){

                    characteristicInfo.append(
                        CharacteristicInfo(hkname: name,
                                            title: title,
                                            id: id,
                                            format: format,
                                            maxValue: dict["MaxValue"] as? NSNumber,
                                            minValue: dict["MinValue"] as? NSNumber,
                                            properties: dict["Properties"] as? Int ?? Int(dict["Properties"] as! String)!,
                                            stepValue: dict["StepValue"] as? NSNumber,
                                            units: dict["Units"] as? String))
                    characteristicFormats.insert(format)

                }
            }
        }
        write("""

        // swiftlint:disable no_grouping_extension
        public extension CharacteristicType {
        """)

        for charateristic in characteristicInfo.sorted(by: { $0.title < $1.title } ) {
            write("\tstatic let \(serviceName(charateristic.title, uuid: charateristic.id)) = CharacteristicType(0x\(charateristic.id.suffix(4)))")
        }
        write("}")


        // Characteristic Formats

        write("""

        //
        // HAP Characteristic Formats
        //
        """)

        characteristicFormats = characteristicFormats.union(["data"])

        write("""

        public enum CharacteristicFormat: String, Codable {
        """)
        for format in characteristicFormats.sorted(by: { $0 < $1 } ) {
            write("\tcase \(format.lowercased())")
        }
        write("}")

        // Characteristic Units

        write("""

        //
        // HAP Characteristic Units
        //
        """)

        var unitInfo = [String]()

        for (name, dict) in units {
            if let title = dict["DefaultDescription"] as? String {
                unitInfo.append(unitName(name))
            }
        }
        write("""

        public enum CharacteristicUnit: String, Codable {
        """)
        for u in unitInfo.sorted(by: { $0 < $1 } ) {
            write("\tcase \(u)")
        }
        write("}")

        write("""

        ///////////////////////////////////////////////////////////////////////////////
        """)

        // Characteristic enumerated types

        write("""

        //
        // HAP Enumerated types
        //

        """)

        write("public class HAP {\n")

        var enumeratedCharacteristics = Set<String>()

        func writeEnumeration(enumName: String, type: String, _ newValues: NSDictionary, max: NSNumber?) -> Bool {

            var values = newValues

            // Check if keys are digits

            let numberedKeys = values.allKeys.compactMap({($0 as? NSNumber)?.intValue ?? Int($0 as? String ?? "x")})
            if numberedKeys.count == values.count {

                // Check if vals are also all digits
                let numberedValues = values.allValues.compactMap({($0 as? NSNumber)?.intValue ?? Int($0 as? String ?? "x")})

                if numberedValues.count == values.count {
                    return false
                }

                // Swap keys and values

                let keys = values.allKeys
                let vals = values.allValues
                values = NSDictionary(objects: keys, forKeys: vals as! [NSCopying])

            }

            write("\tpublic enum \(enumName): \(type), CharacteristicValueType {")
            writeEnumerationCases(values, max: max)
            write("\t}\n")

            return true

        }

        func writeEnumerationCases(_ unsortedCases: NSDictionary, max: NSNumber?) {
            let cases = unsortedCases.sorted(by: {
                if let v0 = $0.value as? NSNumber {
                    return v0.intValue < ($1.value as! NSNumber).intValue
                } else if let v0 = $0.value as? String {
                    return v0 < ($1.value as! String)
                }
                return false
            }).filter( {
                guard let max = max else {
                    return true
                }
                let val: NSNumber
                if let v0 = $0.value as? NSNumber {
                    val = v0
                } else if let v0 = $0.value as? String,
                    let num = NumberFormatter().number(from: v0) {
                    val = num
                } else {
                    return true
                }
                return !(max.compare(val) == .orderedAscending)
            })
            for c in cases {
                if let name = (c.key as? String) {
                    write("\t\tcase \(name.parameterName()) = \(c.value)")
                }
            }

        }

        var enums = [(enumName: String, type: String, newValues: NSDictionary, info: CharacteristicInfo)]()

        for (name, dict) in characteristicConstants {
            let rName = dict["Read"] as? String
            let wName = dict["Write"] as? String
            let rwName = dict["ReadWrite"] as? String
            let rValues = dict["Values"] as? NSDictionary
            let wValues = dict["OutValues"] as? NSDictionary

            if let rName = rName, let values = rValues,
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

            } else if let wName = wName, let values = rValues,
                let info = characteristicInfo.first(where: { $0.hkname == wName }) {

                let enumName = info.title.parameterName().uppercasedFirstLetter()
                let type = typeName(info.format)

                enums.append((enumName: enumName, type: type, newValues: values, info: info))
            }

            if let rwName = rwName, let values = rValues,
                let info = characteristicInfo.first(where: { $0.hkname == rwName }) {

                let enumName = info.title.parameterName().uppercasedFirstLetter()
                let type = typeName(info.format)

                enums.append((enumName: enumName, type: type, newValues: values, info: info))
            }

        }

        // Add any default enums which are not defined in the HAP config
        for defaultType in Inspector.defaultTypes {
            if let enumInfo = enums.first(where: { $0.info.hkname == defaultType.characteristic } ) {
                // Already defined
            } else if let info = characteristicInfo.first(where: { $0.hkname == defaultType.characteristic }) {
                var valuedict = NSMutableDictionary()
                defaultType.values.map( { valuedict[$0.0] = $0.1} )
                enums.append((enumName: defaultType.enumName, type: defaultType.baseType, newValues: valuedict, info: info))
            }
        }

        for (enumName, type, values, info) in enums.sorted(by: { $0.enumName < $1.enumName }) {
            if writeEnumeration(enumName: enumName, type: type, values, max: info.maxValue) {
                enumeratedCharacteristics.insert(info.hkname)
            } else if let defaultType = Inspector.defaultTypes.first(where: { $0.characteristic == info.hkname }) {
                // The HAP config definition couldn't be written, likely because both key and values are digits
                // Fallback to a default definition if it exists
                var valuedict = NSMutableDictionary()
                defaultType.values.map( { valuedict[$0.0] = $0.1} )
                if writeEnumeration(enumName: defaultType.enumName, type: defaultType.baseType, valuedict, max: info.maxValue) {
                    enumeratedCharacteristics.insert(info.hkname)
                }
            }

        }
        write("}\n")


        // Service classes

        write("""
        //
        // HAP Service classes
        //
        """)

        func writeCharacteristicParameters(info: CharacteristicInfo, indentLevel: Int) {
            let indent = String(repeating: "\t", count: indentLevel)
            write("\(indent)type: .\(serviceName(info.title, uuid: info.id))", terminator:"")
            if info.properties & 7 != 7 {
                write(",\n\(indent)permissions: [\(permissions(info.properties))]", terminator:"")
            }
            write(",\n\(indent)description: \"\(info.title)\"", terminator:"")
            if let unit = info.units {
                write(",\n\(indent)unit: .\(unitName(unit))", terminator:"")
            }
            if let max = info.maxValue {
                write(",\n\(indent)maxValue: \(max)", terminator:"")
            }
            if let min = info.minValue {
                write(",\n\(indent)minValue: \(min)", terminator:"")
            }
            if let step = info.stepValue {
                write(",\n\(indent)minStep: \(step)", terminator:"")
            }
            write(")\n")
        }


        func writeCharacteristicProperty(info: CharacteristicInfo) {
            let name = info.title.parameterName()
            let type = enumeratedCharacteristics.contains(info.hkname) ?
                "HAP.\(name.uppercasedFirstLetter())" :
                typeName(info.format)
            write("\t\tpublic let \(name) = GenericCharacteristic<\(type)>(")
            writeCharacteristicParameters(info: info, indentLevel: 3)
        }

        func writeOptionalCharacteristicProperty(info: CharacteristicInfo) {
            let name = info.title.parameterName()
            let type = enumeratedCharacteristics.contains(info.hkname) ?
                "HAP.\(name.uppercasedFirstLetter())" :
                typeName(info.format)
            write("\t\tpublic let \(name): GenericCharacteristic<\(type)>?")
        }


        func writeOptionalCharacteristicInit(info: CharacteristicInfo) {
            let name = info.title.parameterName()
            let enumType = enumeratedCharacteristics.contains(info.hkname) ?
                "HAP.\(name.uppercasedFirstLetter())" :
                typeName(info.format)
            let characteristiceType = ".\(serviceName(info.title, uuid: info.id))"
            write("""

                \t\t\t\(name) = !optionalCharacteristics.contains(\(characteristiceType)) ? nil :
                \t\t\t\tGenericCharacteristic<\(enumType)>(
                """)
            writeCharacteristicParameters(info: info, indentLevel: 4)
            write("""
                \t\t\tif let \(name) = \(name) {
                \t\t\t\tcharacteristics.append(\(name))
                \t\t\t}
                """)
        }
        /*

            if let _ = optionalCharacteristics?.first(where: { $0 == .statusTampered }) {
            let statusTampered = GenericCharacteristic<UInt8>(
            type: .statusTampered,
            permissions: [.read, .events],
            description: "Status Tampered")

            self.statusTampered = statusTampered
            characteristics.append(statusTampered)
            } else {
            self.statusTampered = nil
            }

            statusTampered = !optionalCharacteristics.contains(.statusTampered) ? nil :
            GenericCharacteristic<UInt8>(
            type: .statusTampered,
            permissions: [.read, .events],
            description: "Status Tampered")
            if let statusTampered = statusTampered {
            characteristics.append(statusTampered)
            }


            */

        for service in serviceInfo.sorted(by: { $0.className < $1.className } ) {
            write("""

            extension Service {
            """)
            write("\topen class \(service.className)Base: Service {")

            var requiredCharacteristicPropertyNames = [String]()

            write("\n\t\t// Required Characteristics\n")
            for ch in service.required {
                if let info = characteristicInfo.first(where: { $0.hkname == ch }) {
                    writeCharacteristicProperty(info: info)
                    requiredCharacteristicPropertyNames.append(info.title.parameterName())
                }
            }
            write("\t\t// Optional Characteristics\n")
            for ch in service.optional {
                if let info = characteristicInfo.first(where: { $0.hkname == ch }) {
                    writeOptionalCharacteristicProperty(info: info)
                }
            }

            write("""

                \t\tpublic init(optionalCharacteristics: [CharacteristicType] = []) {

                \t\t\tvar characteristics: [Characteristic] = [\(requiredCharacteristicPropertyNames.joined(separator: ", "))]
                """)

            for ch in service.optional {
                if let info = characteristicInfo.first(where: { $0.hkname == ch }) {
                    writeOptionalCharacteristicInit(info: info)
                }
            }

            write("""

                \t\t\tsuper.init(type: .\(serviceName(service.title, uuid: service.id)), characteristics: characteristics)
                \t\t}
                \t}
                }
                """)
        }
    }
}
