import Foundation
import HTTP

extension HTTPResponse {
    static var noContent: HTTPResponse {
        get {
            return HTTPResponse(status: .noContent)
        }
    }

    static var badRequest: HTTPResponse {
        get {
            return HTTPResponse(status: .badRequest)
        }
    }

    static var notFound: HTTPResponse {
        get {
            return HTTPResponse(status: .notFound)
        }
    }

    static var internalServerError: HTTPResponse {
        get {
            return HTTPResponse(status: .internalServerError)
        }
    }
}
