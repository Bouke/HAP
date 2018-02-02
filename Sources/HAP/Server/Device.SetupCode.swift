import Foundation
import Regex

extension Device {
    public enum SetupCode:Equatable {
        case automatic
        case `default`(String)
        
        // HAP Specification lists certain setup codes as invalid
        public var isValid: Bool {
            switch (self) {
            case .default(let setupCode):
                return SetupCode.isValid(setupCode)
            case .automatic:
                return false
            }
        }
        
        static public func ==(lhs: SetupCode, rhs: SetupCode) -> Bool {
            switch(lhs, rhs) {
            case (.automatic, .automatic):
                return true
            case let (.default(left), .default(right)):
                return left == right
            default:
                return false
            }
        }
        
        internal func getValidCode() -> String {
            switch (self) {
            case .default(let setupCode):
                if isValid {
                    return setupCode
                } else {
                    return SetupCode.generateSetupCode()
                }
            case .automatic:
                return SetupCode.generateSetupCode()
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
        static private func generateSetupCode() -> String {
            let n1 = arc4random_uniform(1000)
            let n2 = arc4random_uniform(100)
            let n3 = arc4random_uniform(1000)
            let setupCode = String(format: "%03ld-%02ld-%03ld", n1, n2, n3)
            
            if !SetupCode.isValid(setupCode) {
                return generateSetupCode()
            }
            return setupCode
        }
        
    }
}
