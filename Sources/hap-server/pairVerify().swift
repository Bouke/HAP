import Foundation
import HTTP
import HKDF

func pairVerify(request: Request) -> Response {
    guard let body = request.body, let data = try? decode(body) else { return Response(status: .BadRequest) }
    switch PairSetupStep(rawValue: UInt8(data: data[Tag.sequence.rawValue]!)) {
    case let x?: print(x, data)
    default: return Response(status: .BadRequest)
    }

    return Response(status: .BadRequest)
}
