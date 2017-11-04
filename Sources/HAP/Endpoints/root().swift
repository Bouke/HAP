import func Evergreen.getLogger
fileprivate let logger = getLogger("hap.endpoints")
typealias Route = (path: String, application: Application)

func root(device: Device) -> Application {
    return logger(router([
        // Unauthenticated endpoints
        ("/", { _, _  in Response(status: .ok, text: "Nothing to see here. Pair this Homekit Accessory with an iOS device.") }),
        ("/pair-setup", pairSetup(device: device)),
        ("/pair-verify", pairVerify(device: device)),

        // Authenticated endpoints
        ("/identify", protect(identify(device: device))),
        ("/accessories", protect(accessories(device: device))),
        ("/characteristics", protect(characteristics(device: device))),
        ("/pairings", protect(pairings(device: device)))
    ]))
}

func logger(_ application: @escaping Application) -> Application {
    return { (connection, request) in
        let response = application(connection, request)
        logger.info("\(connection.socket?.remoteHostname ?? "-") \(request.method) \(request.urlURL.path) \(request.urlURL.query ?? "-") \(response.status.rawValue) \(response.body?.count ?? 0)")
        return response
    }
}

func router(_ routes: [Route]) -> Application {
    return { (connection, request) in
        guard let route = routes.first(where: { $0.path == request.urlURL.path }) else {
            return Response(status: .notFound)
        }
        return route.application(connection, request)
    }
}

func protect(_ application: @escaping Application) -> Application {
    return { (connection, request) in
        guard connection.isAuthenticated else {
            logger.warning("Unauthorized request to \(request.urlURL.path)")
            return .forbidden
        }
        return application(connection, request)
    }
}
