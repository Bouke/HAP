import Foundation
import HTTP

func identify(connection: Connection, request: Request) -> Response {
    //TODO: call accessory's identify callback
    return Response(status: .ok, text: "Got identified")
}
