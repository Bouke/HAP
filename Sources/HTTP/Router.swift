import Foundation

public class Router {
    public typealias Route = (path: String, application: Application)

    let routes: [Route]
    public init(routes: [Route]) {
        self.routes = routes
    }

    public var application: Application {
        return { request in
            print("Request for \(request.requestURL)")
            for route in self.routes {
                if route.path == request.requestURL?.path {
                    return route.application(request)
                }
            }
            return Response(status: .NotFound)
        }
    }
}
