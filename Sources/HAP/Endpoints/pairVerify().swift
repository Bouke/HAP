import func Evergreen.getLogger
import Foundation

fileprivate let logger = getLogger("hap.endpoints.pair-verify")
fileprivate typealias Session = PairVerifyController.Session
fileprivate let SESSION_KEY = "hap.pair-verify.session"
fileprivate enum Error: Swift.Error {
    case noSession
}

func pairVerify(device: Device) -> Application {
    let controller = PairVerifyController(device: device)

    return { (connection, request) in
        var body = Data()
        guard let _ = try? request.read(into: &body), let data: PairTagTLV8 = try? decode(body) else {
            logger.warning("Could not decode message")
            return .badRequest
        }
        guard let state = data[.state]?.first.flatMap({ PairVerifyStep(rawValue: $0) }) else {
            return .badRequest
        }
        do {
            switch state {
            case .startRequest:
                let (response, session) = try controller.startRequest(data)
                connection.context[SESSION_KEY] = session
                return Response(status: .ok, data: encode(response), mimeType: "application/pairing+tlv8")
            case .finishRequest:
                guard let session = connection.context[SESSION_KEY] as? Session else {
                    throw Error.noSession
                }
                let result = try controller.finishRequest(data, session)
                let response = UpgradeResponse(cryptographer: Cryptographer(sharedKey: session.sharedSecret))
                response.headers["Content-Type"] = "application/pairing+tlv8"
                response.body = encode(result)
                return response
            default:
                return .badRequest
            }
        } catch {
            logger.warning(error)
            return .badRequest
        }
    }
}
