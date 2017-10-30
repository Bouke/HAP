import func Evergreen.getLogger
fileprivate let logger = getLogger("hap.endpoints")
typealias Route = (path: String, application: Application)

func root(device: Device) -> Application {
    return logger(router([
        ("/", { _,_  in Response(status: .ok, text: "Nothing to see here. Pair this Homekit Accessory with an iOS device.") }),
        ("/identify", identify(device: device)),
        ("/pair-setup", pairSetup(device: device)),
        ("/pair-verify", pairVerify(device: device)),
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
        for route in routes {
            if route.path == request.urlURL.path {
                return route.application(connection, request)
            }
        }
        return Response(status: .notFound)
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
