import Cryptor
import Foundation
#if os(Linux)
    import Glibc
#endif
import Regex

extension Device {
    public enum SetupCode: ExpressibleByStringLiteral {
        case random
        case override(String)

        public init(stringLiteral value: StringLiteralType) {
            self = .override(value)
        }

        public var isValid: Bool {
            switch self {
            case .override(let setupCode):
                return SetupCode.isValid(setupCode)
            case .random:
                return true
            }
        }

        /// HAP Specification lists certain setup codes as invalid.
        static private func isValid(_ setupCode: String) -> Bool {
            let invalidCodes = ["000-00-000", "111-11-111", "222-22-222",
                                "333-33-333", "444-44-444", "555-55-555",
                                "666-66-666", "777-77-777", "888-88-888",
                                "999-99-999", "123-45-678", "876-54-321"]
            return (setupCode =~ "^\\d{3}-\\d{2}-\\d{3}$") && !invalidCodes.contains(setupCode)
        }

        /// Generate a valid random setup code, used to pair with the device.
        static func generate() -> String {
            var setupCode = ""
            repeat {
                setupCode = String(format: "%03ld-%02ld-%03ld",
                                   arc4random_uniform(1000),
                                   arc4random_uniform(100),
                                   arc4random_uniform(1000))
            } while !SetupCode.isValid(setupCode)
            return setupCode
        }

        /// Generate a random four character setup key, used in setupURI and setupHash
        static internal func generateSetupKey() -> String {
            return String(arc4random_uniform(1679616), radix: 36, uppercase: true)
                    .padLeft(toLength: 4, withPad: "0")
        }
    }
}
