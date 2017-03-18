import HTTPServer
import Foundation

struct Event {
    var status: Response.Status
    var body: Data
    var headers: [String: String] = [:]

    init(status: Response.Status, body: Data, mimeType: String) {
        self.status = status
        self.body = body
        headers["Content-Length"] = "\(body.count)"
        headers["Content-Type"] = mimeType
    }

    func serialized() -> Data {
        // @todo should set additional headers here as well?
        let headers = self.headers.map({ "\($0): \($1)\r\n" }).joined(separator: "")
        return "EVENT/1.0 \(status.rawValue) \(status.description)\r\n\(headers)\r\n".data(using: .utf8)! + body
    }

    init?(valueChangedOfCharacteristic characteristic: AnyCharacteristic) {
        guard let aid = characteristic.service?.accessory?.aid else {
            return nil
        }
        let serialized: [String: [[String: AnyObject]]] = ["characteristics": [
            [
                "aid": aid as AnyObject,
                "iid": characteristic.iid as AnyObject,
                "value": characteristic.valueAsNSObject ?? NSNull()
            ]
            ]]
        guard let body = try? JSONSerialization.data(withJSONObject: serialized, options: []) else {
            abort()
        }
        self.init(status: .ok, body: body, mimeType: "application/hap+json")
    }
}
