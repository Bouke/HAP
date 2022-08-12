import Foundation
import VaporHTTP

func identify(device: Device) -> Responder {
    { _, _ in
        device.delegate?.didRequestIdentification()
        return .noContent
    }
}
