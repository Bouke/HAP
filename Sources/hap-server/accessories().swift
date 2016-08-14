import Foundation
import HTTP
import HKDF

func accessories(connection: Connection, request: Request) -> Response {
    precondition(request.method == .GET)
    let serialized: [String: AnyObject] = [
        "accessories": device.accessories.map { $0.serialize() }
    ]
    let json = try! JSONSerialization.data(withJSONObject: serialized, options: [])
    return Response(data: json, mimeType: "application/hap+json")
}
