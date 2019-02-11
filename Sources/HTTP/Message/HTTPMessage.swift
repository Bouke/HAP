/// An HTTP message.
/// This is the basis of `HTTPRequest` and `HTTPResponse`. It has the general structure of:
///
///     <status line> HTTP/1.1
///     Content-Length: 5
///     Foo: Bar
///
///     hello
///
/// - note: The status line contains information that differentiates requests and responses.
///         If the status line contains an HTTP method and URI it is a request.
///         If the status line contains an HTTP status code it is a response.
///
/// This protocol is useful for adding methods to both requests and responses, such as the ability to serialize
/// content to both message types.
public protocol HTTPMessage: CustomStringConvertible, CustomDebugStringConvertible {
    /// The HTTP version of this message.
    var version: HTTPVersion { get set }

    /// The HTTP headers.
    var headers: HTTPHeaders { get set }

    /// The optional HTTP body.
    var body: HTTPBody { get set }

    /// If this message came from an NIO pipeline, the `Channel` property
    /// may be set. Use this to access things like the allocator or address.
    var channel: Channel? { get }
}

extension HTTPMessage {
    /// See `CustomDebugStringConvertible`
    public var debugDescription: String {
        return description
    }

    /// Updates transport headers for current body.
    /// This should be called automatically be `HTTPRequest` and `HTTPResponse` when their `body` property is set.
    internal mutating func updateTransportHeaders() {
        if let count = body.count?.description {
            headers.remove(name: .transferEncoding)
            if count != headers[.contentLength].first {
                headers.replaceOrAdd(name: .contentLength, value: count)
            }
        } else {
            headers.remove(name: .contentLength)
            if headers[.transferEncoding].first != "chunked" {
                headers.replaceOrAdd(name: .transferEncoding, value: "chunked")
            }
        }
    }
}
