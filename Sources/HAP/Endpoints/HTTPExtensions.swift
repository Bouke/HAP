import Foundation
import VaporHTTP

extension HTTPResponse {
    static var noContent: HTTPResponse {
        HTTPResponse(status: .noContent)
    }

    static var badRequest: HTTPResponse {
        HTTPResponse(status: .badRequest)
    }

    static var notFound: HTTPResponse {
        HTTPResponse(status: .notFound)
    }

    static var internalServerError: HTTPResponse {
        HTTPResponse(status: .internalServerError)
    }
}
