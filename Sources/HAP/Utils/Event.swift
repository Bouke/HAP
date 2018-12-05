// swiftlint:disable unused_optional_binding
import Foundation

struct Event {
    enum Error: Swift.Error {
        case characteristicWithoutAccessory
    }

    var status: Response.Status
    var body: Data
    var headers: [String: String] = [:]

    init(status: Response.Status, body: Data, mimeType: String) {
        self.status = status
        self.body = body
        headers["Content-Length"] = "\(body.count)"
        headers["Content-Type"] = mimeType
    }

    init?(deserialize data: Data) {
        let scanner = DataScanner(data: data)
        let space = " ".data(using: .utf8)!
        let newline = "\r\n".data(using: .utf8)!
        let headerSeparator = ": ".data(using: .utf8)!
        guard
            let _ = scanner.scan("EVENT/1.0 "),
            let statusCode = scanner.scanUpTo(" ").flatMap({ Int($0) }),
            let status = Response.Status(rawValue: statusCode),
            let _ = scanner.scan(space),
            let _ = scanner.scanUpTo("\r\n"),
            let _ = scanner.scan(newline)
            else {
                return nil
        }
        self.status = status
        while true {
            if let _ = scanner.scan(newline) {
                break
            }
            guard
                let key = scanner.scanUpTo(": "),
                let _ = scanner.scan(headerSeparator),
                let value = scanner.scanUpTo("\r\n"),
                let _ = scanner.scan(newline)
                else {
                    return nil
            }
            headers[key] = value
        }
        body = data[scanner.scanLocation..<data.endIndex]
    }

    func serialized() -> Data {
        // @todo should set additional headers here as well?
        let headers = self.headers.map({ "\($0): \($1)\r\n" }).joined()
        return "EVENT/1.0 \(status.description)\r\n\(headers)\r\n".data(using: .utf8)! + body
    }

    init(valueChangedOfCharacteristics characteristics: [Characteristic]) throws {
        var payload = [[String: Any]]()
        for char in characteristics {
            guard let aid = char.service?.accessory?.aid else {
                throw Error.characteristicWithoutAccessory
            }
            payload.append(["aid": aid, "iid": char.iid, "value": char.getValue() ?? NSNull()])
        }
        let serialized = ["characteristics": payload]
        guard let body = try? JSONSerialization.data(withJSONObject: serialized, options: []) else {
            abort()
        }
        self.init(status: .ok, body: body, mimeType: "application/hap+json")
    }
}
