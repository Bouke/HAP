import func Evergreen.getLogger
import Foundation
import HKDF

fileprivate let logger = getLogger("hap.endpoints.accessories")

func accessories(device: Device) -> Application {
    return { (connection, request) in
        guard request.method == "GET" else {
            return .badRequest
        }
        let serialized: [String: Any] = [
            "accessories": device.accessories.map { $0.serialized() }
        ]
        do {
            let json = try JSONSerialization.data(withJSONObject: serialized, options: [])
            return Response(data: json, mimeType: "application/hap+json")
        } catch {
            logger.error("Could not serialize object", error: error)
            return .internalServerError
        }
    }
}
