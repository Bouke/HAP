// swiftlint:disable all
/// Type used for the name of a HTTP header in the `HTTPHeaders` storage.
public struct HTTPHeaderName: Codable, Hashable, CustomStringConvertible {
    /// See `Hashable.hashValue`
    public let hashValue: Int

    /// Lowercased-ASCII version of the header.
    internal let lowercased: String

    /// Create a HTTP header name with the provided String.
    public init(_ name: String) {
        let lowercased = name.lowercased()
        self.lowercased = lowercased
        self.hashValue = lowercased.hashValue
    }

    /// See `ExpressibleByStringLiteral.init(stringLiteral:)`
    public init(stringLiteral: String) {
        self.init(stringLiteral)
    }

    /// See `ExpressibleByStringLiteral.init(unicodeScalarLiteral:)`
    public init(unicodeScalarLiteral: String) {
        self.init(unicodeScalarLiteral)
    }

    /// See `ExpressibleByStringLiteral.init(extendedGraphemeClusterLiteral:)`
    public init(extendedGraphemeClusterLiteral: String) {
        self.init(extendedGraphemeClusterLiteral)
    }

    /// See `CustomStringConvertible.description`
    public var description: String {
        return lowercased
    }

    /// See `Equatable.==`
    public static func ==(lhs: HTTPHeaderName, rhs: HTTPHeaderName) -> Bool {
        return lhs.lowercased == rhs.lowercased
    }

    // https://www.iana.org/assignments/message-headers/message-headers.xhtml
    // Permanent Message Header Field Names

    /// A-IM header.
    public static let aIM = HTTPHeaderName("A-IM")
    /// Accept header.
    public static let accept = HTTPHeaderName("Accept")
    /// Accept-Additions header.
    public static let acceptAdditions = HTTPHeaderName("Accept-Additions")
    /// Accept-Charset header.
    public static let acceptCharset = HTTPHeaderName("Accept-Charset")
    /// Accept-Datetime header.
    public static let acceptDatetime = HTTPHeaderName("Accept-Datetime")
    /// Accept-Encoding header.
    public static let acceptEncoding = HTTPHeaderName("Accept-Encoding")
    /// Accept-Features header.
    public static let acceptFeatures = HTTPHeaderName("Accept-Features")
    /// Accept-Language header.
    public static let acceptLanguage = HTTPHeaderName("Accept-Language")
    /// Accept-Patch header.
    public static let acceptPatch = HTTPHeaderName("Accept-Patch")
    /// Accept-Post header.
    public static let acceptPost = HTTPHeaderName("Accept-Post")
    /// Accept-Ranges header.
    public static let acceptRanges = HTTPHeaderName("Accept-Ranges")
    /// Accept-Age header.
    public static let age = HTTPHeaderName("Age")
    /// Accept-Allow header.
    public static let allow = HTTPHeaderName("Allow")
    /// ALPN header.
    public static let alpn = HTTPHeaderName("ALPN")
    /// Alt-Svc header.
    public static let altSvc = HTTPHeaderName("Alt-Svc")
    /// Alt-Used header.
    public static let altUsed = HTTPHeaderName("Alt-Used")
    /// Alternates header.
    public static let alternates = HTTPHeaderName("Alternates")
    /// Apply-To-Redirect-Ref header.
    public static let applyToRedirectRef = HTTPHeaderName("Apply-To-Redirect-Ref")
    /// Authentication-Control header.
    public static let authenticationControl = HTTPHeaderName("Authentication-Control")
    /// Authentication-Info header.
    public static let authenticationInfo = HTTPHeaderName("Authentication-Info")
    /// Authorization header.
    public static let authorization = HTTPHeaderName("Authorization")
    /// C-Ext header.
    public static let cExt = HTTPHeaderName("C-Ext")
    /// C-Man header.
    public static let cMan = HTTPHeaderName("C-Man")
    /// C-Opt header.
    public static let cOpt = HTTPHeaderName("C-Opt")
    /// C-PEP header.
    public static let cPEP = HTTPHeaderName("C-PEP")
    /// C-PEP-Info header.
    public static let cPEPInfo = HTTPHeaderName("C-PEP-Info")
    /// Cache-Control header.
    public static let cacheControl = HTTPHeaderName("Cache-Control")
    /// CalDav-Timezones header.
    public static let calDAVTimezones = HTTPHeaderName("CalDAV-Timezones")
    /// Close header.
    public static let close = HTTPHeaderName("Close")
    /// Connection header.
    public static let connection = HTTPHeaderName("Connection")
    /// Content-Base header.
    public static let contentBase = HTTPHeaderName("Content-Base")
    /// Content-Disposition header.
    public static let contentDisposition = HTTPHeaderName("Content-Disposition")
    /// Content-Encoding header.
    public static let contentEncoding = HTTPHeaderName("Content-Encoding")
    /// Content-ID header.
    public static let contentID = HTTPHeaderName("Content-ID")
    /// Content-Language header.
    public static let contentLanguage = HTTPHeaderName("Content-Language")
    /// Content-Length header.
    public static let contentLength = HTTPHeaderName("Content-Length")
    /// Content-Location header.
    public static let contentLocation = HTTPHeaderName("Content-Location")
    /// Content-MD5 header.
    public static let contentMD5 = HTTPHeaderName("Content-MD5")
    /// Content-Range header.
    public static let contentRange = HTTPHeaderName("Content-Range")
    /// Content-Script-Type header.
    public static let contentScriptType = HTTPHeaderName("Content-Script-Type")
    /// Content-Style-Type header.
    public static let contentStyleType = HTTPHeaderName("Content-Style-Type")
    /// Content-Type header.
    public static let contentType = HTTPHeaderName("Content-Type")
    /// Content-Version header.
    public static let contentVersion = HTTPHeaderName("Content-Version")
    /// Cookie header.
    public static let cookie = HTTPHeaderName("Cookie")
    /// Cookie2 header.
    public static let cookie2 = HTTPHeaderName("Cookie2")
    /// DASL header.
    public static let dasl = HTTPHeaderName("DASL")
    /// DASV header.
    public static let dav = HTTPHeaderName("DAV")
    /// Date header.
    public static let date = HTTPHeaderName("Date")
    /// Default-Style header.
    public static let defaultStyle = HTTPHeaderName("Default-Style")
    /// Delta-Base header.
    public static let deltaBase = HTTPHeaderName("Delta-Base")
    /// Depth header.
    public static let depth = HTTPHeaderName("Depth")
    /// Derived-From header.
    public static let derivedFrom = HTTPHeaderName("Derived-From")
    /// Destination header.
    public static let destination = HTTPHeaderName("Destination")
    /// Differential-ID header.
    public static let differentialID = HTTPHeaderName("Differential-ID")
    /// Digest header.
    public static let digest = HTTPHeaderName("Digest")
    /// ETag header.
    public static let eTag = HTTPHeaderName("ETag")
    /// Expect header.
    public static let expect = HTTPHeaderName("Expect")
    /// Expires header.
    public static let expires = HTTPHeaderName("Expires")
    /// Ext header.
    public static let ext = HTTPHeaderName("Ext")
    /// Forwarded header.
    public static let forwarded = HTTPHeaderName("Forwarded")
    /// From header.
    public static let from = HTTPHeaderName("From")
    /// GetProfile header.
    public static let getProfile = HTTPHeaderName("GetProfile")
    /// Hobareg header.
    public static let hobareg = HTTPHeaderName("Hobareg")
    /// Host header.
    public static let host = HTTPHeaderName("Host")
    /// HTTP2-Settings header.
    public static let http2Settings = HTTPHeaderName("HTTP2-Settings")
    /// IM header.
    public static let im = HTTPHeaderName("IM")
    /// If header.
    public static let `if` = HTTPHeaderName("If")
    /// If-Match header.
    public static let ifMatch = HTTPHeaderName("If-Match")
    /// If-Modified-Since header.
    public static let ifModifiedSince = HTTPHeaderName("If-Modified-Since")
    /// If-None-Match header.
    public static let ifNoneMatch = HTTPHeaderName("If-None-Match")
    /// If-Range header.
    public static let ifRange = HTTPHeaderName("If-Range")
    /// If-Schedule-Tag-Match header.
    public static let ifScheduleTagMatch = HTTPHeaderName("If-Schedule-Tag-Match")
    /// If-Unmodified-Since header.
    public static let ifUnmodifiedSince = HTTPHeaderName("If-Unmodified-Since")
    /// Keep-Alive header.
    public static let keepAlive = HTTPHeaderName("Keep-Alive")
    /// Label header.
    public static let label = HTTPHeaderName("Label")
    /// Last-Modified header.
    public static let lastModified = HTTPHeaderName("Last-Modified")
    /// Link header.
    public static let link = HTTPHeaderName("Link")
    /// Location header.
    public static let location = HTTPHeaderName("Location")
    /// Lock-Token header.
    public static let lockToken = HTTPHeaderName("Lock-Token")
    /// Man header.
    public static let man = HTTPHeaderName("Man")
    /// Max-Forwards header.
    public static let maxForwards = HTTPHeaderName("Max-Forwards")
    /// Memento-Datetime header.
    public static let mementoDatetime = HTTPHeaderName("Memento-Datetime")
    /// Meter header.
    public static let meter = HTTPHeaderName("Meter")
    /// MIME-Version header.
    public static let mimeVersion = HTTPHeaderName("MIME-Version")
    /// Negotiate header.
    public static let negotiate = HTTPHeaderName("Negotiate")
    /// Opt header.
    public static let opt = HTTPHeaderName("Opt")
    /// Optional-WWW-Authenticate header.
    public static let optionalWWWAuthenticate = HTTPHeaderName("Optional-WWW-Authenticate")
    /// Ordering-Type header.
    public static let orderingType = HTTPHeaderName("Ordering-Type")
    /// Origin header.
    public static let origin = HTTPHeaderName("Origin")
    /// Overwrite header.
    public static let overwrite = HTTPHeaderName("Overwrite")
    /// P3P header.
    public static let p3p = HTTPHeaderName("P3P")
    /// PEP header.
    public static let pep = HTTPHeaderName("PEP")
    /// PICS-Label header.
    public static let picsLabel = HTTPHeaderName("PICS-Label")
    /// Pep-Info header.
    public static let pepInfo = HTTPHeaderName("Pep-Info")
    /// Position header.
    public static let position = HTTPHeaderName("Position")
    /// Pragma header.
    public static let pragma = HTTPHeaderName("Pragma")
    /// Prefer header.
    public static let prefer = HTTPHeaderName("Prefer")
    /// Preference-Applied header.
    public static let preferenceApplied = HTTPHeaderName("Preference-Applied")
    /// ProfileObject header.
    public static let profileObject = HTTPHeaderName("ProfileObject")
    /// Protocol header.
    public static let `protocol` = HTTPHeaderName("Protocol")
    /// Protocol-Info header.
    public static let protocolInfo = HTTPHeaderName("Protocol-Info")
    /// Protocol-Query header.
    public static let protocolQuery = HTTPHeaderName("Protocol-Query")
    /// Protocol-Request header.
    public static let protocolRequest = HTTPHeaderName("Protocol-Request")
    /// Proxy-Authenticate header.
    public static let proxyAuthenticate = HTTPHeaderName("Proxy-Authenticate")
    /// Proxy-Authentication-Info header.
    public static let proxyAuthenticationInfo = HTTPHeaderName("Proxy-Authentication-Info")
    /// Proxy-Authorization header.
    public static let proxyAuthorization = HTTPHeaderName("Proxy-Authorization")
    /// Proxy-Features header.
    public static let proxyFeatures = HTTPHeaderName("Proxy-Features")
    /// Proxy-Instruction header.
    public static let proxyInstruction = HTTPHeaderName("Proxy-Instruction")
    /// Public header.
    public static let `public` = HTTPHeaderName("Public")
    /// Public-Key-Pins header.
    public static let publicKeyPins = HTTPHeaderName("Public-Key-Pins")
    /// Public-Key-Pins-Report-Only header.
    public static let publicKeyPinsReportOnly = HTTPHeaderName("Public-Key-Pins-Report-Only")
    /// Range header.
    public static let range = HTTPHeaderName("Range")
    /// Redirect-Ref header.
    public static let redirectRef = HTTPHeaderName("Redirect-Ref")
    /// Referer header.
    public static let referer = HTTPHeaderName("Referer")
    /// Retry-After header.
    public static let retryAfter = HTTPHeaderName("Retry-After")
    /// Safe header.
    public static let safe = HTTPHeaderName("Safe")
    /// Schedule-Reply header.
    public static let scheduleReply = HTTPHeaderName("Schedule-Reply")
    /// Schedule-Tag header.
    public static let scheduleTag = HTTPHeaderName("Schedule-Tag")
    /// Sec-WebSocket-Accept header.
    public static let secWebSocketAccept = HTTPHeaderName("Sec-WebSocket-Accept")
    /// Sec-WebSocket-Extensions header.
    public static let secWebSocketExtensions = HTTPHeaderName("Sec-WebSocket-Extensions")
    /// Sec-WebSocket-Key header.
    public static let secWebSocketKey = HTTPHeaderName("Sec-WebSocket-Key")
    /// Sec-WebSocket-Protocol header.
    public static let secWebSocketProtocol = HTTPHeaderName("Sec-WebSocket-Protocol")
    /// Sec-WebSocket-Version header.
    public static let secWebSocketVersion = HTTPHeaderName("Sec-WebSocket-Version")
    /// Security-Scheme header.
    public static let securityScheme = HTTPHeaderName("Security-Scheme")
    /// Server header.
    public static let server = HTTPHeaderName("Server")
    /// Set-Cookie header.
    public static let setCookie = HTTPHeaderName("Set-Cookie")
    /// Set-Cookie2 header.
    public static let setCookie2 = HTTPHeaderName("Set-Cookie2")
    /// SetProfile header.
    public static let setProfile = HTTPHeaderName("SetProfile")
    /// SLUG header.
    public static let slug = HTTPHeaderName("SLUG")
    /// SoapAction header.
    public static let soapAction = HTTPHeaderName("SoapAction")
    /// Status-URI header.
    public static let statusURI = HTTPHeaderName("Status-URI")
    /// Strict-Transport-Security header.
    public static let strictTransportSecurity = HTTPHeaderName("Strict-Transport-Security")
    /// Surrogate-Capability header.
    public static let surrogateCapability = HTTPHeaderName("Surrogate-Capability")
    /// Surrogate-Control header.
    public static let surrogateControl = HTTPHeaderName("Surrogate-Control")
    /// TCN header.
    public static let tcn = HTTPHeaderName("TCN")
    /// TE header.
    public static let te = HTTPHeaderName("TE")
    /// Timeout header.
    public static let timeout = HTTPHeaderName("Timeout")
    /// Topic header.
    public static let topic = HTTPHeaderName("Topic")
    /// Trailer header.
    public static let trailer = HTTPHeaderName("Trailer")
    /// Transfer-Encoding header.
    public static let transferEncoding = HTTPHeaderName("Transfer-Encoding")
    /// TTL header.
    public static let ttl = HTTPHeaderName("TTL")
    /// Urgency header.
    public static let urgency = HTTPHeaderName("Urgency")
    /// URI header.
    public static let uri = HTTPHeaderName("URI")
    /// Upgrade header.
    public static let upgrade = HTTPHeaderName("Upgrade")
    /// User-Agent header.
    public static let userAgent = HTTPHeaderName("User-Agent")
    /// Variant-Vary header.
    public static let variantVary = HTTPHeaderName("Variant-Vary")
    /// Vary header.
    public static let vary = HTTPHeaderName("Vary")
    /// Via header.
    public static let via = HTTPHeaderName("Via")
    /// WWW-Authenticate header.
    public static let wwwAuthenticate = HTTPHeaderName("WWW-Authenticate")
    /// Want-Digest header.
    public static let wantDigest = HTTPHeaderName("Want-Digest")
    /// Warning header.
    public static let warning = HTTPHeaderName("Warning")
    /// X-Frame-Options header.
    public static let xFrameOptions = HTTPHeaderName("X-Frame-Options")

    // https://www.iana.org/assignments/message-headers/message-headers.xhtml
    // Provisional Message Header Field Names
    /// Access-Control header.
    public static let accessControl = HTTPHeaderName("Access-Control")
    /// Access-Control-Allow-Credentials header.
    public static let accessControlAllowCredentials = HTTPHeaderName("Access-Control-Allow-Credentials")
    /// Access-Control-Allow-Headers header.
    public static let accessControlAllowHeaders = HTTPHeaderName("Access-Control-Allow-Headers")
    /// Access-Control-Allow-Methods header.
    public static let accessControlAllowMethods = HTTPHeaderName("Access-Control-Allow-Methods")
    /// Access-Control-Allow-Origin header.
    public static let accessControlAllowOrigin = HTTPHeaderName("Access-Control-Allow-Origin")
    /// Access-Control-Expose-Headers header.
    public static let accessControlExpose = HTTPHeaderName("Access-Control-Expose-Headers")
    /// Access-Control-Max-Age header.
    public static let accessControlMaxAge = HTTPHeaderName("Access-Control-Max-Age")
    /// Access-Control-Request-Method header.
    public static let accessControlRequestMethod = HTTPHeaderName("Access-Control-Request-Method")
    /// Access-Control-Request-Headers header.
    public static let accessControlRequestHeaders = HTTPHeaderName("Access-Control-Request-Headers")
    /// Compliance header.
    public static let compliance = HTTPHeaderName("Compliance")
    /// Content-Transfer-Encoding header.
    public static let contentTransferEncoding = HTTPHeaderName("Content-Transfer-Encoding")
    /// Cost header.
    public static let cost = HTTPHeaderName("Cost")
    /// EDIINT-Features header.
    public static let ediintFeatures = HTTPHeaderName("EDIINT-Features")
    /// Message-ID header.
    public static let messageID = HTTPHeaderName("Message-ID")
    /// Method-Check header.
    public static let methodCheck = HTTPHeaderName("Method-Check")
    /// Method-Check-Expires header.
    public static let methodCheckExpires = HTTPHeaderName("Method-Check-Expires")
    /// Non-Compliance header.
    public static let nonCompliance = HTTPHeaderName("Non-Compliance")
    /// Optional header.
    public static let optional = HTTPHeaderName("Optional")
    /// Referer-Root header.
    public static let refererRoot = HTTPHeaderName("Referer-Root")
    /// Resolution-Hint header.
    public static let resolutionHint = HTTPHeaderName("Resolution-Hint")
    /// Resolver-Location header.
    public static let resolverLocation = HTTPHeaderName("Resolver-Location")
    /// SubOK header.
    public static let subOK = HTTPHeaderName("SubOK")
    /// Subst header.
    public static let subst = HTTPHeaderName("Subst")
    /// Title header.
    public static let title = HTTPHeaderName("Title")
    /// UA-Color header.
    public static let uaColor = HTTPHeaderName("UA-Color")
    /// UA-Media header.
    public static let uaMedia = HTTPHeaderName("UA-Media")
    /// UA-Pixels header.
    public static let uaPixels = HTTPHeaderName("UA-Pixels")
    /// UA-Resolution header.
    public static let uaResolution = HTTPHeaderName("UA-Resolution")
    /// UA-Windowpixels header.
    public static let uaWindowpixels = HTTPHeaderName("UA-Windowpixels")
    /// Version header.
    public static let version = HTTPHeaderName("Version")
    /// X-Device-Accept header.
    public static let xDeviceAccept = HTTPHeaderName("X-Device-Accept")
    /// X-Device-Accept-Charset header.
    public static let xDeviceAcceptCharset = HTTPHeaderName("X-Device-Accept-Charset")
    /// X-Device-Accept-Encoding header.
    public static let xDeviceAcceptEncoding = HTTPHeaderName("X-Device-Accept-Encoding")
    /// X-Device-Accept-Language header.
    public static let xDeviceAcceptLanguage = HTTPHeaderName("X-Device-Accept-Language")
    /// X-Device-User-Agent header.
    public static let xDeviceUserAgent = HTTPHeaderName("X-Device-User-Agent")
    /// X-Requested-With header.
    public static let xRequestedWith = HTTPHeaderName("X-Requested-With")
}
