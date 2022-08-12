import Foundation
import HTTP

import Logging
fileprivate let logger = Logger(label: "hap.endpoints")

typealias Route = (path: String, application: Responder)

func root(device: Device) -> Responder {
    logger(router([
        // Unauthenticated endpoints
        ("/", { _, _  in HTTPResponse(body: "Nothing to see here. Pair this Homekit Accessory with an iOS device.") }),
        ("/pair-setup", pairSetup(device: device)),
        ("/pair-verify", pairVerify(device: device)),

        // Authenticated endpoints
        ("/identify", protect(device, identify(device: device))),
        ("/accessories", protect(device, accessories(device: device))),
        ("/characteristics", protect(device, characteristics(device: device))),
        ("/pairings", protect(device, pairings(device: device)))
    ]))
}

func logger(_ application: @escaping Responder) -> Responder {
    { context, request in
        let response = application(context, request)
        let client = context.channel.remoteAddress?.description ?? "N/A"
        let method = request.method
        let path = request.urlString
        let status = response.status.code
        let length = response.body.count ?? 0
        logger.info("\(client) \(method) \(path) \(status) \(length)")
        logger.debug(
            """
            Response Message: \
            \(String(data: response.body.data ?? "nil".data(using: .utf8)!, encoding: .utf8) ?? "-")
            """)
       return response
    }
}

func router(_ routes: [Route]) -> Responder {
    { connection, request in
        guard let route = routes.first(where: { $0.path == request.url.path }) else {
            return .notFound
        }
        return route.application(connection, request)
    }
}

func protect(_ device: Device, _ application: @escaping Responder) -> Responder {
    { context, request in
        guard device.controllerHandler?.isChannelVerified(channel: context.channel) ?? false else {
            logger.warning("Unauthorized request to \(request.urlString)")
            return HTTPResponse(
                status: .unauthorized,
                body: "You are not authorized. Start a session through /pair-verify.")
        }
        return application(context, request)
    }
}
