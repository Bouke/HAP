import Foundation
import HTTPServer

func identify(device: Device) -> Application {
    return { (connection, request) in
        _ = device.onIdentify.map { $0(nil) }
        return Response(status: .noContent)
    }
}

