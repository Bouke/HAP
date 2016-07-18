import Foundation
import HTTP

func identify(request: Request) -> Response {
    //TODO: call accessory's identify callback
    return Response(status: .OK, text: "Got identified")
}
