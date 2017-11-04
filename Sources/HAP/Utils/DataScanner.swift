import Foundation

class DataScanner {
    let data: Data
    var scanLocation: Data.Index = 0
    init(data: Data) {
        self.data = data
    }

    func scanUpTo(_ marker: Data) -> Data? {
        guard let markerPosition = data.range(of: marker, in: scanLocation..<data.endIndex) else {
            return nil
        }
        guard markerPosition.lowerBound - scanLocation > 1 else {
            return Data()
        }
        defer { scanLocation = markerPosition.lowerBound }
        return data[scanLocation..<markerPosition.lowerBound]
    }

    func scan(_ marker: Data) -> Data? {
        guard let upperBound = data.index(scanLocation, offsetBy: marker.count, limitedBy: data.count) else {
            return nil
        }
        guard data[scanLocation..<upperBound] == marker else {
            return nil
        }
        scanLocation = upperBound
        return marker
    }

    // MARK: - String helpers
    func scanUpTo(_ marker: String) -> String? {
        return marker
            .data(using: .utf8)
            .flatMap { scanUpTo($0) }
            .flatMap { String(data: $0, encoding: .utf8) }
    }

    func scan(_ marker: String) -> String? {
        return marker
            .data(using: .utf8)
            .flatMap { scan($0) }
            .flatMap { String(data: $0, encoding: .utf8) }
    }
}
