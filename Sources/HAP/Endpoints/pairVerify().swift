import Foundation
import Logging
import VaporHTTP

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

    return future({ context, request in
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

            // HAP Specification 4.8.4:
            // Must return authentication error to Verify Finish Response (M4) when
            // 1. fail verifiction of authentication tag on encrypted keys
            // 2. decryption fails
            // 3. pairing ID is not recognised
            // 4. fail verification of iOS device signature

            let response: PairTagTLV8?

            switch error {
            case
                PairVerifyController.Error.couldNotDecrypt,
                PairVerifyController.Error.couldNotDecode,
                PairVerifyController.Error.noPublicKeyForUser,
                PairVerifyController.Error.invalidSignature:

                response = [
                    (.state, Data([PairVerifyStep.finishResponse.rawValue])),
                    (.error, Data([PairError.authenticationFailed.rawValue]))
                ]
            default:
                // For other errors, respond with an HTTP error 400 (bad request)
                // PairVerifyController.Error
                // .invalidParameters
                // .noSession
                // .couldNotSetupSession
                // .couldNotEncrypt
                // Ed25519.Error
                // .invalidSignature
                // .couldNotSign
                response = nil
            }

            if let response = response {
                return HTTPResponse(tags: response)
            } else {
                return .badRequest
            }
        }
    })
}
