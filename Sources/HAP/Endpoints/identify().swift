import Foundation
import VaporHTTP

func identify(device: Device) -> Responder {
    future({ _, _ in
        device.delegate?.didRequestIdentification()
        return .noContent
    })
}
