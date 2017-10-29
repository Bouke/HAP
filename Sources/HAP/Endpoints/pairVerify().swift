import Foundation
import HKDF
import CLibSodium
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap.pairVerify")

func pairVerify(device: Device) -> Application {
    let controller = PairVerifyController(device: device)
    
    return { (connection, request) in
        var body = Data()
        guard let _ = try? request.read(into: &body), let data: PairTagTLV8 = try? decode(body) else {
            logger.warning("Could not decode message")
            return .badRequest
        }
        guard let sequence = data[.sequence]?.first.flatMap({ PairVerifyStep(rawValue: $0) }) else {
            return .badRequest
        }

        switch sequence {
        case .startRequest:
            logger.info("Pair verify started")
            let response: PairTagTLV8
            let session: PairVerifyController.Session
            do {
                (response, session) = try controller.startRequest(data)
            } catch {
                logger.warning(error)
                return .badRequest
            }
            connection.context["hap.pairVerify.session"] = session
            return Response(status: .ok, data: encode(response), mimeType: "application/pairing+tlv8")

        case .finishRequest:
            guard let session = connection.context["hap.pairVerify.session"] as? PairVerifyController.Session else {
                logger.warning("No session")
                return .badRequest
            }
            let result: PairTagTLV8
            do {
                result = try controller.finishRequest(data, session)
            } catch {
                logger.warning(error)
                return .badRequest
            }
            
            let response = UpgradeResponse(cryptographer: Cryptographer(sharedKey: session.sharedSecret))
            response.headers["Content-Type"] = "application/pairing+tlv8"
            response.body = encode(result)
            return response

        default: return .badRequest
        }
    }
}
