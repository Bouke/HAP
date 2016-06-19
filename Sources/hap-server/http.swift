//
//  http.swift
//  HAP
//
//  Created by Bouke Haarsma on 19-06-16.
//
//

import Foundation

class Message {
    internal var boxed: CFHTTPMessage
    let headers: Headers

    internal init(boxed: CFHTTPMessage) {
        self.boxed = boxed
        headers = Headers(boxed: boxed)
    }

    var isHeaderComplete: Bool {
        return CFHTTPMessageIsHeaderComplete(boxed)
    }

    var isRequest: Bool {
        return CFHTTPMessageIsRequest(boxed)
    }

    var body: Data? {
        get {
            return CFHTTPMessageCopyBody(boxed)?.takeRetainedValue() as Data?
        }
        set {
            CFHTTPMessageSetBody(boxed, newValue ?? Data())
        }
    }

    func serialized() -> Data? {
        return CFHTTPMessageCopySerializedMessage(boxed)?.takeRetainedValue() as Data?
    }

    var httpVersion: String {
        return CFHTTPMessageCopyVersion(boxed).takeRetainedValue() as String
    }

    class Headers {
        typealias Key = String
        typealias Value = String

        internal var boxed: CFHTTPMessage

        init(boxed: CFHTTPMessage) {
            self.boxed = boxed
        }

        subscript(key: Key) -> Value? {
            get {
                return CFHTTPMessageCopyHeaderFieldValue(boxed, key)?.takeRetainedValue() as String?
            }
            set {
                CFHTTPMessageSetHeaderFieldValue(boxed, key, newValue)
            }
        }

        // replace with Collection protocol implementation
        func copy() -> [Key: Value] {
            let cf = CFHTTPMessageCopyAllHeaderFields(self.boxed)?.takeRetainedValue() as Dictionary?
            return cf as! [Key: Value]
        }
    }
}

extension Message: CustomDebugStringConvertible {
    var debugDescription: String {
        guard let serialized = serialized() else { return "Message (could not be serialized)" }
        return String(data: serialized, encoding: .utf8) ?? "Message (could not be serialized)"
    }
}


class Request: Message {
    init() {
        super.init(boxed: CFHTTPMessageCreateEmpty(nil, true).takeRetainedValue())
    }

    func append(data: Data) -> Bool {
        return data.withUnsafeBytes {
            return CFHTTPMessageAppendBytes(boxed, $0, data.count)
        }
    }

    var requestMethod: String? {
        return CFHTTPMessageCopyRequestMethod(boxed)?.takeRetainedValue() as String?
    }

    var requestURL: URL? {
        return CFHTTPMessageCopyRequestURL(boxed)?.takeRetainedValue() as URL?
    }
}


class Response: Message {
    init(statusCode: Int, statusDescription: String, httpVersion: String) {
        super.init(boxed: CFHTTPMessageCreateResponse(nil, statusCode, statusDescription, httpVersion).takeRetainedValue())
    }

    enum Status: Int, CustomDebugStringConvertible {
        case OK = 200, Created = 201, Accepted = 202
        case MovedPermanently = 301
        case BadRequest = 400, Unauthorized = 401, Forbidden = 403, NotFound = 404
        case InternalServerError = 500

        var description: String {
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

        var debugDescription: String {
            return "\(rawValue) (\(description))"
        }
    }

    convenience init(status: Status, body: String?, mimeType: String = "text/html") {
        self.init(statusCode: status.rawValue, statusDescription: status.description, httpVersion: kCFHTTPVersion1_1 as String)
        if let data = body?.data(using: .utf8) {
            headers["Content-Type"] = "\(mimeType); charset=utf8"
            headers["Content-Length"] = "\(data.count)"
            self.body = data
        }
    }
}


typealias Application = (Request) -> Response

class Server: NSObject, StreamDelegate {
    var application: Application

    init(application: Application) {
        self.application = application
    }

    var connections: [Connection] = []

    func accept(inputStream: InputStream, outputStream: NSOutputStream) {
        connections.append(Connection(server: self, inputStream: inputStream, outputStream: outputStream))
    }

    func forget(connection: Connection) {
        if let index = connections.index(of: connection) {
            connections.remove(at: index)
        }
    }
}


class Connection: NSObject, StreamDelegate {
    weak var server: Server?

    let inputStream: InputStream
    let outputStream: NSOutputStream
    let request: Request
    var response: Response?

    init(server: Server, inputStream: InputStream, outputStream: NSOutputStream) {
        self.server = server
        self.inputStream = inputStream
        self.outputStream = outputStream
        self.request = Request()
        super.init()
        open()
    }

    func open() {
        inputStream.delegate = self
        inputStream.schedule(in: RunLoop.main(), forMode: .defaultRunLoopMode)
        inputStream.open()
    }

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch (aStream, eventCode) {
        case (inputStream, Stream.Event.openCompleted): break

        case (inputStream, Stream.Event.hasBytesAvailable):
            var buffer = Data(capacity: 1024)!
            buffer.count = 1024
            buffer.count = buffer.withUnsafeMutableBytes {
                inputStream.read($0, maxLength: 1024)
            }
            precondition(request.append(data: buffer))

            if request.isHeaderComplete {
                response = server?.application(request)
                print(response)

                outputStream.delegate = self
                outputStream.schedule(in: .main(), forMode: .defaultRunLoopMode)
                outputStream.open()
            }

        case (inputStream, Stream.Event.endEncountered): break


        case (outputStream, Stream.Event.openCompleted): break

        case (outputStream, Stream.Event.hasSpaceAvailable):
            guard let data = response?.serialized() else {
                abort()
            }
            let written = data.withUnsafeBytes {
                outputStream.write($0, maxLength: data.count)
            }

            precondition(written == data.count)
            close()

        default:
            close()
        }
    }

    func close() {
        server?.forget(connection: self)
        inputStream.close()
        outputStream.close()
    }

    deinit {
        close()
    }
}

