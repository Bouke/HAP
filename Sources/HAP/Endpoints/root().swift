import Foundation
import HTTP

import Logging
fileprivate let logger = Logger(label: "hap.endpoints")

typealias Route = (path: String, application: Responder)

func root(device: Device) -> Responder {
    return logger(router([
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
    return { context, request in
        let response = application(context, request)
        // swiftlint:disable:next line_length
        logger.info("\(context.channel.remoteAddress?.description ?? "N/A") \(request.method) \(request.urlString) \(response.status.code) \(response.body.count ?? 0)")
        logger.debug("Response Message: \(String(data: response.body.data ?? "nil".data(using: .utf8)!, encoding: .utf8) ?? "-")\n")
       return response
    }
}

func router(_ routes: [Route]) -> Responder {
    return { connection, request in
        guard let route = routes.first(where: { $0.path == request.url.path }) else {
            return .notFound
        }
        return route.application(connection, request)
    }
}

func protect(_ device: Device, _ application: @escaping Responder) -> Responder {
    return { context, request in
        guard device.controllerHandler?.isChannelVerified(channel: context.channel) ?? false else {
            logger.warning("Unauthorized request to \(request.urlString)")
            return HTTPResponse(
                status: .unauthorized,
                body: "You are not authorized. Start a session through /pair-verify.")
        }
        return application(context, request)
    }
}
