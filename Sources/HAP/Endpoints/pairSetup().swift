import Cryptor
import func Evergreen.getLogger
import Foundation
import SRP
import HTTP

fileprivate let logger = getLogger("hap.pairSetup")
fileprivate typealias Session = PairSetupController.Session
fileprivate let SESSION_KEY = "hap.pair-setup.session"
fileprivate enum Error: Swift.Error {
    case noSession
}

// swiftlint:disable:next cyclomatic_complexity
func pairSetup(device: Device) -> Responder {
    let group = Group.N3072
    let algorithm = Digest.Algorithm.sha512

    let username = "Pair-Setup"
    let (salt, verificationKey) = createSaltedVerificationKey(username: username,
                                                              password: device.setupCode,
                                                              group: group,
                                                              algorithm: algorithm)
    let controller = PairSetupController(device: device)
    func createSession() -> Session {
        return Session(server: SRP.Server(username: username,
                                          salt: salt,
                                          verificationKey: verificationKey,
                                          group: group,
                                          algorithm: algorithm))
    }
    func getSession(_ connection: Server.Connection) throws -> Session {
        guard let session = connection.context[SESSION_KEY] as? Session else {
            throw Error.noSession
        }
        return session
    }

    // TODO: this memory is not freed, not thread-safe either
    var sessions: [ObjectIdentifier: Session] = [:]

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
                sessions[ObjectIdentifier(context.channel)] = session

            // M3: iOS Device -> Accessory -- `SRP Verify Request'
            case .verifyRequest:
                guard let session = sessions[ObjectIdentifier(context.channel)] else {
                    throw PairSetupController.Error.invalidSetupState
                }
                response = try controller.verifyRequest(data, session)

            // M5: iOS Device -> Accessory -- `Exchange Request'
            case .keyExchangeRequest:
                guard let session = sessions[ObjectIdentifier(context.channel)] else {
                    throw PairSetupController.Error.invalidSetupState
                }
                response = try controller.keyExchangeRequest(data, session)

            // Unknown state - return error and abort
            default:
                throw PairSetupController.Error.invalidParameters
            }
        } catch {
            logger.warning(error)

            sessions[ObjectIdentifier(context.channel)] = nil

            try? device.changePairingState(.notPaired)

            switch error {
            case PairSetupController.Error.invalidParameters:
                response = [
                    (.state, Data(bytes: [PairSetupStep.waiting.rawValue])),
                    (.error, Data(bytes: [PairError.unknown.rawValue]))
                ]
            case PairSetupController.Error.alreadyPaired:
                response = [
                    (.state, Data(bytes: [PairSetupStep.startResponse.rawValue])),
                    (.error, Data(bytes: [PairError.unavailable.rawValue]))
                ]
            case PairSetupController.Error.alreadyPairing:
                response = [
                    (.state, Data(bytes: [PairSetupStep.startResponse.rawValue])),
                    (.error, Data(bytes: [PairError.busy.rawValue]))
                ]
            case PairSetupController.Error.invalidSetupState:
                response = [
                    (.state, Data(bytes: [PairSetupStep.verifyResponse.rawValue])),
                    (.error, Data(bytes: [PairError.unknown.rawValue]))
                ]
            case PairSetupController.Error.authenticationFailed:
                response = [
                    (.state, Data(bytes: [PairSetupStep.verifyResponse.rawValue])),
                    (.error, Data(bytes: [PairError.authenticationFailed.rawValue]))
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
