import Foundation
import HTTP

extension HTTPResponse {
    static var noContent: HTTPResponse {
        return HTTPResponse(status: .noContent)
    }

    static var badRequest: HTTPResponse {
        return HTTPResponse(status: .badRequest)
    }

    static var notFound: HTTPResponse {
        return HTTPResponse(status: .notFound)
    }

    static var internalServerError: HTTPResponse {
        return HTTPResponse(status: .internalServerError)
    }
}
