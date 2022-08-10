import Crypto
import Foundation

extension SymmetricKey {
    var rawRepresentation: Data {
        withUnsafeBytes({ Data($0) })
    }
}
