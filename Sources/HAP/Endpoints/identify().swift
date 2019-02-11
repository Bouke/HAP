import Foundation
import HTTP

func identify(device: Device) -> Responder {
    return { context, request in
        device.delegate?.didRequestIdentification()
        return .noContent
    }
}
