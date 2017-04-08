import Cryptor
import func Evergreen.getLogger
import Foundation
import SRP

fileprivate let logger = getLogger("hap.pairSetup")
fileprivate typealias Session = PairSetupController.Session
fileprivate let SESSION_KEY = "hap.pair-setup.session"

func pairSetup(device: Device) -> Application {
    let group = Group.N3072
    let algorithm = Digest.Algorithm.sha512

    let username = "Pair-Setup"
    let (salt, verificationKey) = createSaltedVerificationKey(username: username,
                                                              password: device.pin,
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
    return { (connection, request) in
        var body = Data()
        guard let _ = try? request.readAllData(into: &body), let data: PairTagTLV8 = try? decode(body) else {
            return .badRequest
        }
        print(body.hex)
        print(data)
        guard let sequence = data[.sequence]?.first.flatMap({ PairSetupStep(rawValue: $0) }) else {
            return .badRequest
        }
        let session = (connection.context[SESSION_KEY] as? Session) ?? createSession()
        let response: PairTagTLV8?
        do {
            switch sequence {
            case .startRequest:
                response = controller.startRequest(data, session)
            case .verifyRequest:
                response = controller.verifyRequest(data, session)
            case .keyExchangeRequest:
                response = try controller.keyExchangeRequest(data, session)
            default:
                response = nil
            }
        } catch {
            logger.warning(error)
            response = nil
        }
        if let response = response {
            return Response(status: .ok, data: encode(response), mimeType: "application/pairing+tlv8")
        } else {
            return .badRequest
        }
    }
}
