import Foundation

/// Can be converted to an `HTTPBody` without the possibility of failure.
public protocol LosslessHTTPBodyRepresentable {
    /// Converts `self` to an `HTTPBody`.
    func convertToHTTPBody() -> HTTPBody
}

/// `String` can be represented as an `HTTPBody`.
extension String: LosslessHTTPBodyRepresentable {
    /// See `LosslessHTTPBodyRepresentable`.
    public func convertToHTTPBody() -> HTTPBody {
        return HTTPBody(string: self)
    }
}

/// `Data` can be represented as an `HTTPBody`.
extension Data: LosslessHTTPBodyRepresentable {
    /// See `LosslessHTTPBodyRepresentable`.
    public func convertToHTTPBody() -> HTTPBody {
        return HTTPBody(data: self)
    }
}

/// `StaticString` can be represented as an `HTTPBody`.
extension StaticString: LosslessHTTPBodyRepresentable {
    /// See `LosslessHTTPBodyRepresentable`.
    public func convertToHTTPBody() -> HTTPBody {
        return HTTPBody(staticString: self)
    }
}

/// `ByteBuffer` can be represented as an `HTTPBody`.
extension ByteBuffer: LosslessHTTPBodyRepresentable {
    /// See `LosslessHTTPBodyRepresentable`.
    public func convertToHTTPBody() -> HTTPBody {
        return HTTPBody(buffer: self)
    }
}
