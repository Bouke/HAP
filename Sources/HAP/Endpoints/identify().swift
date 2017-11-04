import Foundation

func identify(device: Device) -> Application {
    return { (connection, request) in
        _ = device.onIdentify.map { $0(nil) }
        return Response(status: .noContent)
    }
}
