import Foundation
import HTTP
import Logging

fileprivate let logger = Logger(label: "hap.endpoints.pair-verify")
fileprivate typealias Session = PairVerifyController.Session
fileprivate let SESSION_KEY = "hap.pair-verify.session"
fileprivate enum Error: Swift.Error {
    case noSession
    case unsupportedOperation
}

func pairVerify(device: Device) -> Responder {
    let controller = PairVerifyController(device: device)

    func getSession(for context: RequestContext) -> Session? {
        context.session["PairVerify"] as? Session
    }

    func setSession(for context: RequestContext, to session: Session?) {
        context.session["PairVerify"] = session as AnyObject?
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
                setSession(for: context, to: session)
                return HTTPResponse(tags: response)

            case .finishRequest:
                guard let session = getSession(for: context) else {
                    throw Error.noSession
                }

                defer {
                    setSession(for: context, to: nil)
                }

                let (result, pairing) = try controller.finishRequest(data, session)
                context.triggerUserOutboundEvent(PairingEvent.verified(pairing), promise: nil)

                let sharedKey = session.sharedSecret.withUnsafeBytes({ Data($0) })
                context.triggerUserOutboundEvent(CryptographyEvent.sharedKey(sharedKey), promise: nil)

                return HTTPResponse(tags: result)

            default:
                throw Error.unsupportedOperation
            }
        } catch {
            logger.warning("Could not verify pairing: \(error)")
            setSession(for: context, to: nil)
            return .badRequest
        }
    }
}
