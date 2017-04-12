import Foundation

import func Evergreen.getLogger

fileprivate let logger = getLogger("hap.http.router")

class Router {
    typealias Route = (path: String, application: Application)

    let routes: [Route]
    init(routes: [Route]) {
        self.routes = routes
    }

    var application: Application {
        return { (connection, request) in
            logger.info("\(request.method) \(request.urlURL.path)")
            for route in self.routes {
                if route.path == request.urlURL.path {
                    return route.application(connection, request)
                }
            }
            return Response(status: .notFound)
        }
    }
}
