import Foundation
import HKDF

func accessories(device: Device) -> Application {
    return { (connection, request) in
        precondition(request.method == "GET")
        let serialized: [String: Any] = [
            "accessories": device.accessories.map { $0.serialized() }
        ]
        let json = try! JSONSerialization.data(withJSONObject: serialized, options: [])
        return Response(data: json, mimeType: "application/hap+json")
    }
}
