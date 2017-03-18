import Foundation

public class Router {
    public typealias Route = (path: String, application: Application)

    let routes: [Route]
    public init(routes: [Route]) {
        self.routes = routes
    }

    public var application: Application {
        return { (connection, request) in
            logger.info("\(request.method!) \(request.URL!.path)")
            for route in self.routes {
                if route.path == request.URL?.path {
                    return route.application(connection, request)
                }
            }
            return Response(status: .notFound)
        }
    }
}
