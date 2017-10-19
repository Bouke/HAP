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

    init?(valueChangedOfCharacteristics characteristics: [Characteristic]) {
        var payload = [[String: Any]]()
        for c in characteristics {
            guard let aid = c.service?.accessory?.aid else {
                break
            }
            payload.append(["aid": aid, "iid": c.iid, "value": c.getValue() ?? NSNull()])
        }
        guard payload.count > 0 else { return nil }

        let serialized = ["characteristics": payload]

        guard let body = try? JSONSerialization.data(withJSONObject: serialized, options: []) else {
            abort()
        }
        self.init(status: .ok, body: body, mimeType: "application/hap+json")
    }

}
