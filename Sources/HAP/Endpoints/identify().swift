import Foundation
import HTTP

func identify(device: Device) -> Responder {
    { _, _ in
        device.delegate?.didRequestIdentification()
        return .noContent
    }
}
