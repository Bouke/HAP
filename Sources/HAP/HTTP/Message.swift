import Foundation

class Response {
    var status = Status.ok

    var headers = [String: String]()
    
    var body: Data? {
        didSet {
            headers["Content-Length"] = "\(body?.count ?? 0)"
        }
    }
    
    var text: String? {
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
    
    enum Status: Int, CustomStringConvertible {
        case ok = 200, created = 201, accepted = 202, noContent = 204, multiStatus = 207
        case movedPermanently = 301
        case badRequest = 400, unauthorized = 401, forbidden = 403, notFound = 404
        case methodNotAllowed = 405
        case unprocessableEntity = 422
        case internalServerError = 500

        public var description: String {
            switch self {
            case .ok: return "200 OK"
            case .created: return "201 Created"
            case .accepted: return "202 Accepted"
            case .noContent: return "204 No Content"
            case .multiStatus: return "207 Multi-Status"
            case .movedPermanently: return "301 Moved Permanently"
            case .badRequest: return "400 Bad Request"
            case .unauthorized: return "401 Unauthorized"
            case .forbidden: return "403 Forbidden"
            case .notFound: return "404 Not Found"
            case .methodNotAllowed: return "405 Method Not Allowed"
            case .unprocessableEntity: return "422 Unprocessable Entity"
            case .internalServerError: return "500 Internal Server Error"
            }
        }
    }

    init(status: Status) {
        self.status = status
        headers["Content-Length"] = "0"
    }

    convenience init(status: Status = .ok, data: Data, mimeType: String) {
        self.init(status: status)
        headers["Content-Type"] = mimeType
        // Defer setting body, so that body.didSet will be called.
        defer {
            self.body = data
        }
    }

    convenience init(status: Status = .ok, text: String, mimeType: String = "text/html") {
        guard let data = text.data(using: .utf8) else {
            abort()
        }
        self.init(status: status, data: data, mimeType: "\(mimeType); charset=utf8")
    }
}

extension Response {
    static var ok: Response { return Response(status: .ok) }
    static var badRequest: Response { return  Response(status: .badRequest) }
    static var forbidden: Response { return  Response(status: .forbidden) }
    static var methodNotAllowed: Response { return  Response(status: .methodNotAllowed) }
    static var unprocessableEntity: Response { return  Response(status: .unprocessableEntity) }
    static var notFound: Response { return  Response(status: .notFound) }
    static var internalServerError: Response { return  Response(status: .internalServerError) }
}
