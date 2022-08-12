import Foundation
import VaporHTTP

import Logging
fileprivate let logger = Logger(label: "hap.endpoints")

typealias Route = (path: String, application: Responder)

func root(device: Device) -> Responder {
    logger(router([
        // Unauthenticated endpoints
        ("/", future({ _, _ in
            HTTPResponse(body: "Nothing to see here. Pair this Homekit Accessory with an iOS device.") })),
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
        let promise = context.channel.eventLoop.makePromise(of: HTTPResponse.self)
        promise.completeWith(application(context, request))
        promise.futureResult.whenSuccess { response in
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
        }
        return promise.futureResult
    }
}

func router(_ routes: [Route]) -> Responder {
    { context, request in
        guard let route = routes.first(where: { $0.path == request.url.path }) else {
            let promise = context.channel.eventLoop.makePromise(of: HTTPResponse.self)
            promise.succeed(.notFound)
            return promise.futureResult
        }
        return route.application(context, request)
    }
}

func protect(_ device: Device, _ application: @escaping Responder) -> Responder {
    { context, request in
        guard device.controllerHandler?.isChannelVerified(channel: context.channel) ?? false else {
            logger.warning("Unauthorized request to \(request.urlString)")
            let promise = context.channel.eventLoop.makePromise(of: HTTPResponse.self)
            promise.succeed(HTTPResponse(status: .unauthorized,
                                         body: "You are not authorized. Start a session through /pair-verify."))
            return promise.futureResult
        }
        return application(context, request)
    }
}

func future(_ sync: @escaping (RequestContext, HTTPRequest) -> HTTPResponse) -> Responder {
    { context, request in
        let promise = context.channel.eventLoop.makePromise(of: HTTPResponse.self)
        promise.succeed(sync(context, request))
        return promise.futureResult
    }
}
