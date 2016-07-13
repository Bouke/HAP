//: Playground - noun: a place where people can play

import Cocoa
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

//    lazy var headers: [String: String]? = {
//        precondition(self.isHeaderComplete, "headers are not complete")
//        let cf = CFHTTPMessageCopyAllHeaderFields(self.boxed)?.takeRetainedValue() as Dictionary?
//        return cf as? [String: String]
//    }()

    var body: Data? {
        return CFHTTPMessageCopyBody(boxed)?.takeRetainedValue() as Data?
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
}



//Dictionary


let request = "GET / HTTP/1.1\r\nHost: 10.0.1.16\r\nAccept: Text\r\n\r\nHello, world"

let r2 = Request()
r2.append(data: request.data(using: .utf8)!)
r2.isHeaderComplete
r2.requestMethod
r2.requestURL
r2.httpVersion
r2.headers

let r3 = Response(statusCode: 200, statusDescription: "OK", httpVersion: "HTTP/1.1")
r3.httpVersion
r3.headers["Encoding"] = "utf8"
r3.headers.copy()


//r3.headers
//r3.body
