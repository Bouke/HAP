import Foundation

public class Message {
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
            CFHTTPMessageSetBody(boxed, newValue ?? Data())
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
                return CFHTTPMessageCopyHeaderFieldValue(boxed, key)?.takeRetainedValue() as String?
            }
            set {
                CFHTTPMessageSetHeaderFieldValue(boxed, key, newValue)
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
        return serialized.withUnsafeBytes { String(cString: $0) }
    }
}


public class Request: Message {
    enum Error: Swift.Error {
        case couldNotAppendData
    }

    init() {
        super.init(boxed: CFHTTPMessageCreateEmpty(nil, true).takeRetainedValue())
    }

    func append(data: Data) throws {
        guard data.withUnsafeBytes({
            CFHTTPMessageAppendBytes(boxed, $0, data.count)
        }) else {
            throw Error.couldNotAppendData
        }
    }

    public var requestMethod: String? {
        precondition(isHeaderComplete)
        return CFHTTPMessageCopyRequestMethod(boxed)?.takeRetainedValue() as String?
    }

    public var requestURL: URL? {
        precondition(isHeaderComplete)
        return CFHTTPMessageCopyRequestURL(boxed)?.takeRetainedValue() as URL?
    }
}


public class Response: Message {

    public enum Status: Int, CustomDebugStringConvertible {
        case OK = 200, Created = 201, Accepted = 202
        case MovedPermanently = 301
        case BadRequest = 400, Unauthorized = 401, Forbidden = 403, NotFound = 404
        case InternalServerError = 500

        public var description: String {
            switch self {
            case .OK: return "OK"
            case .Created: return "Created"
            case .Accepted: return "Accepted"
            case .MovedPermanently: return "Moved Permanently"
            case .BadRequest: return "Bad Request"
            case .Unauthorized: return "Unauthorized"
            case .Forbidden: return "Forbidden"
            case .NotFound: return "Not Found"
            case .InternalServerError: return "Internal Server Error"
            }
        }

        public var debugDescription: String {
            return "\(rawValue) (\(description))"
        }
    }

    public init(status: Status, text: String? = nil, mimeType: String? = "text/html") {
        super.init(boxed: CFHTTPMessageCreateResponse(nil, status.rawValue, status.description, kCFHTTPVersion1_1 as String).takeRetainedValue())
        if let data = text?.data(using: .utf8), let mimeType = mimeType {
            headers["Content-Type"] = "\(mimeType); charset=utf8"
            headers["Content-Length"] = "\(data.count)"
            self.body = data
        }
    }

    var status: String? {
        return CFHTTPMessageCopyResponseStatusLine(boxed)?.takeRetainedValue() as String?
    }
}
