import Foundation

func identify(device: Device) -> Application {
    return { connection, request in
        device.delegate?.didRequestIdentification()
        return Response(status: .noContent)
    }
}
