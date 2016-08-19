import Foundation
import HTTP

func identify(device: Device) -> Application {
    return { (connection, request) in
        //TODO: call accessory's identify callback
        return Response(status: .ok, text: "Got identified")
    }
}

