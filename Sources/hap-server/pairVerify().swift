import Foundation
import HTTP
import HKDF

func pairVerify(request: Request) -> Response {
    guard let body = request.body, let data: PairTagTLV8 = try? decode(body) else { return Response(status: .BadRequest) }
    switch PairVerifyStep(rawValue: data[.sequence]![0]) {
    case let x?: print(x, data)
    default: return Response(status: .BadRequest)
    }

    return Response(status: .BadRequest)
}
