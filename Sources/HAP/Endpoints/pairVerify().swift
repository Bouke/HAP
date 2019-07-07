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

    // TODO: this memory is not freed
    var threadUnsafeSessions: [ObjectIdentifier: Session] = [:]
    let rwQueue = DispatchQueue(label: "HAP-PairVerify-\(device.identifier)-lock", attributes: .concurrent)

    func getSession(for context: RequestContext) -> Session? {
        var session: Session?
        rwQueue.sync { // Concurrent read
            session = threadUnsafeSessions[ObjectIdentifier(context.channel)]
        }
        return session
    }

    func setSession(for context: RequestContext, to session: Session?) {
        rwQueue.async(flags: .barrier) {
            threadUnsafeSessions[ObjectIdentifier(context.channel)] = session
        }
    }
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
                setSession(for:context, to: session)
                return HTTPResponse(tags: response)

            case .finishRequest:
                defer {
                    setSession(for:context, to: nil)
                }
                guard let session = getSession(for:context) else {
                    throw Error.noSession
                }

                let (result, pairing) = try controller.finishRequest(data, session)
                context.triggerUserOutboundEvent(PairingEvent.verified(pairing), promise: nil)

                return HTTPResponse(
                    headers: HTTPHeaders([
                        ("x-shared-key", session.sharedSecret.base64EncodedString()),
                        ("Content-Type", "application/pairing+tlv8")
                    ]),
                    body: encode(result))

            default:
                return .badRequest
            }
        } catch {
            logger.warning(error)
            return .badRequest
        }
    }
}
