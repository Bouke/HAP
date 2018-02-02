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
            do {
                for _ in 0..<100 {
                    // Note that these setup codes are not evenly distributed.
                    let n1 = try UInt16(bytes: Random.generate(byteCount: 2)) % 1000
                    let n2 = try UInt8(bytes: Random.generate(byteCount: 1)) % 100
                    let n3 = try UInt16(bytes: Random.generate(byteCount: 2)) % 1000

                    let setupCode = String(format: "%03ld-%02ld-%03ld", n1, n2, n3)

                    guard SetupCode.isValid(setupCode) else {
                        continue
                    }

                    return setupCode
                }
                fatalError("Could not generate random setup code")
            } catch {
                fatalError("Could not generate random setup code: \(error)")
            }
        }

        /// Generate a random four character setup key, used in setupURI and setupHash
        static internal func generateSetupKey() -> String {
            do {
                let key = try UInt32(bytes: Random.generate(byteCount: 4)) % 1_679_616
                return String(key, radix: 36, uppercase: true)
            } catch {
                fatalError("Could not generate random setup key: \(error)")
            }
        }
    }
}
