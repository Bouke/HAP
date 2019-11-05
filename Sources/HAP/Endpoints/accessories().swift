import Logging
import Foundation
import HKDF
import HTTP

fileprivate let logger = Logger(label: "hap.endpoints.accessories")

func accessories(device: Device) -> Responder {
    return { context, request in
        guard request.method == .GET else {
            return .badRequest
        }
        let serialized: [String: Any] = [
            "accessories": device.accessories.map { $0.serialized() }
        ]
        do {
            let json = try JSONSerialization.data(withJSONObject: serialized, options: [])
            return HTTPResponse(
                headers: HTTPHeaders([
                    ("Content-Type", "application/hap+json")
                ]),
                body: json)
        } catch {
            logger.error("Could not serialize object: \(error)")
            return .internalServerError
        }
    }
}
