import Crypto
import Foundation
import HTTP
import Logging
import SRP

fileprivate let logger = Logger(label: "hap.pairSetup")
fileprivate typealias Session = PairSetupController.Session
fileprivate let SESSION_KEY = "hap.pair-setup.session"
fileprivate enum Error: Swift.Error {
    case noSession
}

// swiftlint:disable:next cyclomatic_complexity
func pairSetup(device: Device) -> Responder {
    let group = Group.N3072

    let username = "Pair-Setup"
    let (salt, verificationKey) = createSaltedVerificationKey(using: SHA512.self,
                                                              group: group,
                                                              username: username,
                                                              password: device.setupCode)
    let controller = PairSetupController(device: device)
    func createSession() -> Session {
        Session(server: SRP.Server<SHA512>(username: username,
                                           salt: salt,
                                           verificationKey: verificationKey,
                                           group: group))
    }

    func getSession(for context: RequestContext) -> Session? {
        context.session["PairSetup"] as? Session
    }

    func setSession(for context: RequestContext, to session: Session?) {
        context.session["PairSetup"] = session as AnyObject?
    }

    return { context, request in
        guard
            let body = request.body.data,
            let data: PairTagTLV8 = try? decode(body),
            let sequence = data[.state]?.first.flatMap({ PairSetupStep(rawValue: $0) })
        else {
            return .badRequest
        }
        let response: PairTagTLV8?
        do {
            switch sequence {

            // M1: iOS Device -> Accessory -- `SRP Start Request'
            case .startRequest:
                let session = createSession()
                response = try controller.startRequest(data, session)
                setSession(for: context, to: session)

            // M3: iOS Device -> Accessory -- `SRP Verify Request'
            case .verifyRequest:
                guard let session = getSession(for: context) else {
                    throw PairSetupController.Error.invalidSetupState
                }
                response = try controller.verifyRequest(data, session)

            // M5: iOS Device -> Accessory -- `Exchange Request'
            case .keyExchangeRequest:
                guard let session = getSession(for: context) else {
                    throw PairSetupController.Error.invalidSetupState
                }
                response = try controller.keyExchangeRequest(data, session)

            // Unknown state - return error and abort
            default:
                throw PairSetupController.Error.invalidParameters
            }
        } catch {
            logger.warning("Could not complete pair setup: \(error)")

            setSession(for: context, to: nil)

            try? device.changePairingState(.notPaired)

            switch error {
            case PairSetupController.Error.invalidParameters:
                response = [
                    (.state, Data([PairSetupStep.waiting.rawValue])),
                    (.error, Data([PairError.unknown.rawValue]))
                ]
            case PairSetupController.Error.alreadyPaired:
                response = [
                    (.state, Data([PairSetupStep.startResponse.rawValue])),
                    (.error, Data([PairError.unavailable.rawValue]))
                ]
            case PairSetupController.Error.alreadyPairing:
                response = [
                    (.state, Data([PairSetupStep.startResponse.rawValue])),
                    (.error, Data([PairError.busy.rawValue]))
                ]
            case PairSetupController.Error.invalidSetupState:
                response = [
                    (.state, Data([PairSetupStep.verifyResponse.rawValue])),
                    (.error, Data([PairError.unknown.rawValue]))
                ]
            case PairSetupController.Error.authenticationFailed:
                response = [
                    (.state, Data([PairSetupStep.verifyResponse.rawValue])),
                    (.error, Data([PairError.authenticationFailed.rawValue]))
                ]
            default:
                response = nil
            }
        }

        if let response = response {
            return HTTPResponse(tags: response)
        } else {
            return .badRequest
        }
    }
}
