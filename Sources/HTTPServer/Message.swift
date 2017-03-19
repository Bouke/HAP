import Foundation

open class Message {
    internal var boxed: CFHTTPMessage
    public let headers: Headers

    internal init(boxed: CFHTTPMessage) {
        self.boxed = boxed
        headers = Headers(boxed: boxed)
    }

    public var isHeaderComplete: Bool {
        return CFHTTPMessageIsHeaderComplete(boxed)
    }

    public var isRequest: Bool {
        return CFHTTPMessageIsRequest(boxed)
    }

    public var body: Data? {
        get {
            return CFHTTPMessageCopyBody(boxed)?.takeRetainedValue() as Data?
        }
        set {
            headers["Content-Length"] = "\(newValue?.count ?? 0)"
            CFHTTPMessageSetBody(boxed, (newValue ?? Data()) as CFData)
        }
    }

    public var text: String? {
        get {
            guard let body = body else { return nil }
            // todo use correct encoding...
            return String(data: body, encoding: .utf8)
        }
    }

    func serialized() -> Data? {
        return CFHTTPMessageCopySerializedMessage(boxed)?.takeRetainedValue() as Data?
    }

    public var httpVersion: String {
        return CFHTTPMessageCopyVersion(boxed).takeRetainedValue() as String
    }

    public class Headers {
        public typealias Key = String
        public typealias Value = String

        internal var boxed: CFHTTPMessage

        init(boxed: CFHTTPMessage) {
            self.boxed = boxed
        }

        public subscript(key: Key) -> Value? {
            get {
                return CFHTTPMessageCopyHeaderFieldValue(boxed, key as CFString)?.takeRetainedValue() as String?
            }
            set {
                CFHTTPMessageSetHeaderFieldValue(boxed, key as CFString, newValue as CFString?)
            }
        }

        // replace with Collection protocol implementation
        public func copy() -> [Key: Value] {
            let cf = CFHTTPMessageCopyAllHeaderFields(self.boxed)?.takeRetainedValue() as Dictionary?
            return cf as! [Key: Value]
        }
    }
}

extension Message: CustomDebugStringConvertible {
    public var debugDescription: String {
        precondition(isHeaderComplete)
        guard let serialized = serialized() else { return "Message (could not be serialized)" }
        return serialized.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in String(cString: ptr) }
    }
}


open class Response: Message {
    public enum Status: Int, CustomDebugStringConvertible {
        case ok = 200, created = 201, accepted = 202, noContent = 204
        case movedPermanently = 301
        case badRequest = 400, unauthorized = 401, forbidden = 403, notFound = 404
        case internalServerError = 500

        public var description: String {
            switch self {
            case .ok: return "OK"
            case .created: return "Created"
            case .accepted: return "Accepted"
            case .noContent: return "No Content"
            case .movedPermanently: return "Moved Permanently"
            case .badRequest: return "Bad Request"
            case .unauthorized: return "Unauthorized"
            case .forbidden: return "Forbidden"
            case .notFound: return "Not Found"
            case .internalServerError: return "Internal Server Error"
            }
        }

        public var debugDescription: String {
            return "\(rawValue) (\(description))"
        }
    }

    public init(status: Status) {
        super.init(boxed: CFHTTPMessageCreateResponse(nil, status.rawValue, status.description as CFString?, kCFHTTPVersion1_1).takeRetainedValue())
        headers["Content-Length"] = "0"
    }

    public convenience init(status: Status = .ok, data: Data, mimeType: String) {
        self.init(status: status)
        headers["Content-Type"] = mimeType
        headers["Content-Length"] = "\(data.count)"
        self.body = data
    }

    public convenience init(status: Status = .ok, text: String, mimeType: String = "text/html") {
        guard let data = text.data(using: .utf8) else {
            abort()
        }
        self.init(status: status, data: data, mimeType: "\(mimeType); charset=utf8")
    }

    var status: String? {
        return CFHTTPMessageCopyResponseStatusLine(boxed)?.takeRetainedValue() as String?
    }
}

extension Response {
    public static var ok: Response { return Response(status: .ok) }
    public static var badRequest: Response { return  Response(status: .badRequest) }
    public static var notFound: Response { return  Response(status: .notFound) }
}
