import Foundation

extension Data {
    init?(hex: String) {
        guard hex.characters.count % 2 == 0 else { return nil }
        self = Data()
        var index = hex.characters.startIndex
        while true {
            guard let next = hex.characters.index(index, offsetBy: 2, limitedBy: hex.characters.endIndex) else { break }
            guard let byte = UInt8(String(hex.characters[index..<next]), radix: 16) else { return nil }
            self.append(byte)
            index = next
        }
    }
}
