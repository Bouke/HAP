import Foundation
import HTTP

import func Evergreen.getLogger
fileprivate let logger = getLogger("hap.endpoints")

typealias Route = (path: String, application: Responder)

func root(device: Device) -> Responder {
    return logger(router([
        // Unauthenticated endpoints
        ("/", { _, _  in HTTPResponse(body: "Nothing to see here. Pair this Homekit Accessory with an iOS device.") }),
        ("/pair-setup", pairSetup(device: device)),
        ("/pair-verify", pairVerify(device: device)),

        // Authenticated endpoints
        ("/identify", protect(identify(device: device))),
        ("/accessories", protect(accessories(device: device))),
        ("/characteristics", protect(characteristics(device: device))),
        ("/pairings", protect(pairings(device: device)))
    ]))
}

func logger(_ application: @escaping Responder) -> Responder {
    return { context, request in
        let response = application(context, request)
        logger.info("\(context.channel.remoteAddress) \(request.method) \(request.urlString) (request.url.path) \(response.status.code) \(response.body.count ?? 0)")
//        logger.debug("- Response Messagea: \(String(data: response.body.data ?? Data(), encoding: .utf8) ?? "-")")
        logger.debug(request.description)
        logger.debug(response.description)
        return response
    }
}

func router(_ routes: [Route]) -> Responder {
    return { connection, request in
        guard let route = routes.first(where: { $0.path == request.url.path }) else {
            return HTTPResponse(status: .notFound)
        }
        return route.application(connection, request)
    }
}

func protect(_ application: @escaping Responder) -> Responder {
    return { connection, request in
        // TODO!
//        guard connection.isAuthenticated else {
//            logger.warning("Unauthorized request to \(request.urlURL.path)")
//            return .forbidden
//        }
        return application(connection, request)
    }
}
