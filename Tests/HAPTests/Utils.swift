import Foundation
@testable import HAP
@testable import KituraNet

final class MockRequest: ServerRequest {
    /// The set of headers received with the incoming request
    var headers: HeadersContainer

    /// The URL from the request in string form
    /// This contains just the path and query parameters starting with '/'
    /// Use 'urlURL' for the full URL
    @available(*, deprecated, message: "This contains just the path and query parameters starting with '/'. use 'urlURL' instead")
    var urlString: String {
        return urlURL.path
    }

    /// The URL from the request in UTF-8 form
    /// This contains just the path and query parameters starting with '/'
    /// Use 'urlURL' for the full URL
    var url: Data {
        return urlURL.path.data(using: .utf8)!
    }

    /// The URL from the request as URLComponents
    /// URLComponents has a memory leak on linux as of swift 3.0.1. Use 'urlURL' instead
    @available(*, deprecated, message: "URLComponents has a memory leak on linux as of swift 3.0.1. use 'urlURL' instead")
    var urlComponents: URLComponents {
        return URLComponents(url: urlURL, resolvingAgainstBaseURL: false)!
    }

    /// The URL from the request
    var urlURL: URL

    /// The IP address of the client
    var remoteAddress = "127.0.0.1"

    /// Major version of HTTP of the request
    var httpVersionMajor: UInt16? = 1

    /// Minor version of HTTP of the request
    var httpVersionMinor: UInt16? = 1

    /// The HTTP Method specified in the request
    var method: String

    var body: Data

    /// Read data from the body of the request
    ///
    /// - Parameter data: A Data struct to hold the data read in.
    ///
    /// - Throws: Socket.error if an error occurred while reading from the socket
    /// - Returns: The number of bytes read
    func read(into data: inout Data) throws -> Int {
        data.append(body)
        return body.count
    }

    /// Read a string from the body of the request.
    ///
    /// - Throws: Socket.error if an error occurred while reading from the socket
    /// - Returns: An Optional string
    func readString() throws -> String? {
        return String(data: body, encoding: .utf8)
    }

    /// Read all of the data in the body of the request
    ///
    /// - Parameter data: A Data struct to hold the data read in.
    ///
    /// - Throws: Socket.error if an error occurred while reading from the socket
    /// - Returns: The number of bytes read
    func readAllData(into data: inout Data) throws -> Int {
        data.append(body)
        return body.count
    }

    init(method: String, url: URL, body: Data, headers: [String: String] = [:]) {
        self.method = method
        self.urlURL = url
        self.body = body
        self.headers = HeadersContainer()
        for (key, value) in headers {
            self.headers.append(key, value: value)
        }
    }

    convenience init(method: String, path: String, body: Data, headers: [String: String] = [:]) {
        self.init(method: method,
                  url: URL(string: path, relativeTo: URL(string: "http://fake-host/"))!,
                  body: body,
                  headers: headers)
    }

    static func get(path: String, headers: [String: String] = [:]) -> MockRequest {
        return self.init(method: "GET", path: path, body: Data(), headers: headers)
    }
}

class MockConnection: HAP.Server.Connection {
    var sideChannelCallback: ((Data) -> Void)?

    override func writeOutOfBand(_ data: Data) {
        sideChannelCallback?(data)
    }
}
