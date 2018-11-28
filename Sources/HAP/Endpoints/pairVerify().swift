import func Evergreen.getLogger
import Foundation
import HTTP

fileprivate let logger = getLogger("hap.endpoints.pair-verify")
fileprivate typealias Session = PairVerifyController.Session
fileprivate let SESSION_KEY = "hap.pair-verify.session"
fileprivate enum Error: Swift.Error {
    case noSession
}

func pairVerify(device: Device) -> Responder {
    let controller = PairVerifyController(device: device)

    // TODO: this memory is not freed, not thread-safe either
    var sessions: [ObjectIdentifier: PairVerifyController.Session] = [:]

    return { context, request in
        guard
            let body = request.body.data,
            let data: PairTagTLV8 = try? decode(body)
        else {
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
                sessions[ObjectIdentifier(context.channel)] = session
                return HTTPResponse(tags: response)

            case .finishRequest:
                defer {
                    sessions[ObjectIdentifier(context.channel)] = nil
                }
                guard let session = sessions[ObjectIdentifier(context.channel)] else {
                    throw Error.noSession
                }

                let (result, pairing) = try controller.finishRequest(data, session)
                // TODO: what's this used for?
                //connection.pairing = pairing

                let response = HTTPResponse(
                    headers: HTTPHeaders([
                        ("x-shared-key", session.sharedSecret.base64EncodedString()),
                        ("Content-Type", "application/pairing+tlv8"),
                    ]),
                    body: encode(result))

                return response

//                let response = UpgradeResponse(cryptographer: Cryptographer(sharedKey: session.sharedSecret))
//                response.headers["Content-Type"] = "application/pairing+tlv8"
//                response.body = encode(result)
//                return response

            default:
                return .badRequest
            }
        } catch {
            logger.warning(error)
            return .badRequest
        }
    }
}
