/// An HTTP response from a server back to the client.
///
///     let httpRes = HTTPResponse(status: .ok)
///
/// See `HTTPClient` and `HTTPServer`.
public struct HTTPResponse: HTTPMessage {
    /// Internal storage is an NIO `HTTPResponseHead`
    internal var head: HTTPResponseHead

    // MARK: Properties

    /// The HTTP version that corresponds to this response.
    public var version: HTTPVersion {
        get { return head.version }
        set { head.version = newValue }
    }

    /// The HTTP response status.
    public var status: HTTPResponseStatus {
        get { return head.status }
        set { head.status = newValue }
    }

    /// The header fields for this HTTP response.
    /// The `"Content-Length"` and `"Transfer-Encoding"` headers will be set automatically
    /// when the `body` property is mutated.
    public var headers: HTTPHeaders {
        get { return head.headers }
        set { head.headers = newValue }
    }

    /// The `HTTPBody`. Updating this property will also update the associated transport headers.
    ///
    ///     httpRes.body = HTTPBody(string: "Hello, world!")
    ///
    /// Also be sure to set this message's `contentType` property to a `MediaType` that correctly
    /// represents the `HTTPBody`.
    public var body: HTTPBody {
        didSet { updateTransportHeaders() }
    }

    /// If set, reference to the NIO `Channel` this response came from.
    public var channel: Channel?

    /// See `CustomStringConvertible`
    public var description: String {
        var desc: [String] = []
        desc.append("HTTP/\(version.major).\(version.minor) \(status.code) \(status.reasonPhrase)")
        desc.append(headers.debugDescription)
        desc.append(body.description)
        return desc.joined(separator: "\n")
    }

    // MARK: Init

    /// Creates a new `HTTPResponse`.
    ///
    ///     let httpRes = HTTPResponse(status: .ok)
    ///
    /// - parameters:
    ///     - status: `HTTPResponseStatus` to use. This defaults to `HTTPResponseStatus.ok`
    ///     - version: `HTTPVersion` of this response, should usually be (and defaults to) 1.1.
    ///     - headers: `HTTPHeaders` to include with this response.
    ///                Defaults to empty headers.
    ///                The `"Content-Length"` and `"Transfer-Encoding"` headers will be set automatically.
    ///     - body: `HTTPBody` for this response, defaults to an empty body.
    ///             See `LosslessHTTPBodyRepresentable` for more information.
    public init(
        status: HTTPResponseStatus = .ok,
        version: HTTPVersion = .init(major: 1, minor: 1),
        headers: HTTPHeaders = .init(),
        body: LosslessHTTPBodyRepresentable = HTTPBody()
    ) {
        let head = HTTPResponseHead(version: version, status: status, headers: headers)
        self.init(
            head: head,
            body: body.convertToHTTPBody(),
            channel: nil
        )
        updateTransportHeaders()
    }

    /// Internal init that creates a new `HTTPResponse` without sanitizing headers.
    internal init(head: HTTPResponseHead, body: HTTPBody, channel: Channel?) {
        self.head = head
        self.body = body
        self.channel = channel
    }
}
