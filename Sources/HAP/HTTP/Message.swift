import Foundation

open class Response {
    public var status = Status.ok

    public var headers = [String: String]()
    
    public var body: Data? {
        didSet {
            headers["Content-Length"] = "\(body?.count ?? 0)"
        }
    }
    
    public var text: String? {
        guard let body = body else { return nil }
        return String(data: body, encoding: .utf8)
    }
    
    func serialized() -> Data {
        var header = "HTTP/1.1 \(status)\r\n"
        for (key, value) in headers {
            header.append(key)
            header.append(": ")
            header.append(value)
            header.append("\r\n")
        }
        header.append("\r\n")
        return header.data(using: .utf8)! + (body ?? Data())
    }
    
    public enum Status: Int, CustomStringConvertible {
        case ok = 200, created = 201, accepted = 202, noContent = 204
        case movedPermanently = 301
        case badRequest = 400, unauthorized = 401, forbidden = 403, notFound = 404
        case internalServerError = 500

        public var description: String {
            switch self {
            case .ok: return "200 OK"
            case .created: return "201 Created"
            case .accepted: return "202 Accepted"
            case .noContent: return "204 No Content"
            case .movedPermanently: return "301 Moved Permanently"
            case .badRequest: return "400 Bad Request"
            case .unauthorized: return "401 Unauthorized"
            case .forbidden: return "403 Forbidden"
            case .notFound: return "404 Not Found"
            case .internalServerError: return "500 Internal Server Error"
            }
        }
    }

    public init(status: Status) {
        self.status = status
        headers["Content-Length"] = "0"
    }

    public convenience init(status: Status = .ok, data: Data, mimeType: String) {
        self.init(status: status)
        headers["Content-Type"] = mimeType
        // Defer setting body, so that body.didSet will be called.
        defer {
            self.body = data
        }
    }

    public convenience init(status: Status = .ok, text: String, mimeType: String = "text/html") {
        guard let data = text.data(using: .utf8) else {
            abort()
        }
        self.init(status: status, data: data, mimeType: "\(mimeType); charset=utf8")
    }
}

extension Response {
    public static var ok: Response { return Response(status: .ok) }
    public static var badRequest: Response { return  Response(status: .badRequest) }
    public static var notFound: Response { return  Response(status: .notFound) }
}
