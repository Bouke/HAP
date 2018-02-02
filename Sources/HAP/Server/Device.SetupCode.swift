import Foundation
#if os(Linux)
import Glibc
#endif
import Regex

extension Device {
    public enum SetupCode {
        case random
        case override(String)

        // HAP Specification lists certain setup codes as invalid
        public var isValid: Bool {
            switch self {
            case .override(let setupCode):
                return SetupCode.isValid(setupCode)
            case .random:
                return true
            }
        }

        // HAP Specification lists certain setup codes as invalid
        static private func isValid(_ setupCode: String) -> Bool {
            let invalidCodes = ["000-00-000", "111-11-111", "222-22-222",
                                "333-33-333", "444-44-444", "555-55-555",
                                "666-66-666", "777-77-777", "888-88-888",
                                "999-99-999", "123-45-678", "876-54-321"]
            return (setupCode =~ "^\\d{3}-\\d{2}-\\d{3}$") && !invalidCodes.contains(setupCode)
        }

        // Generate a valid random setup code, used to pair with the device
        static func generate() -> String {
            let n1 = arc4random_uniform(1000)
            let n2 = arc4random_uniform(100)
            let n3 = arc4random_uniform(1000)
            let setupCode = String(format: "%03ld-%02ld-%03ld", n1, n2, n3)

            if !SetupCode.isValid(setupCode) {
                return generate()
            }
            return setupCode
        }

        // Generate a random four character setup key, used in setupURI and setupHash
        static internal func generateSetupKey() -> String {
            return String(arc4random_uniform(1679616), radix: 36, uppercase: true)
        }

#if os(Linux)
        static let seededRandom: Bool  = {
            srandom(UInt32(time(nil)))
            return true
        }()

        static func arc4random_uniform(_ max: UInt) -> UInt {
            precondition(seededRandom)
            return UInt(Glibc.random()) % max
        }
#endif
    }
}
