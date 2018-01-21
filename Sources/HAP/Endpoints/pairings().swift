import Foundation
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap.endpoints.pairings")

func pairings(device: Device) -> Application {
    return { (connection, request) in
        var body = Data()
        guard request.method == "POST" else {
            return .methodNotAllowed
        }
        guard
            (try? request.readAllData(into: &body)) != nil,
            let data: PairTagTLV8 = try? decode(body),
            data[.state]?[0] == PairStep.request.rawValue,
            let method = data[.pairingMethod].flatMap({PairingMethod(rawValue: $0[0])}),
            let username = data[.identifier]
            else {
                return .badRequest
        }
        logger.debug("Updating pairings data: \(data), method: \(method)")

        switch method {
        case .addPairing:
            guard let publicKey = data[.publicKey] else {
                return .badRequest
            }
            device.pairings[username] = publicKey
            logger.info("Added pairing for \(String(data: username, encoding: .utf8)!)")
        case .removePairing:
            device.pairings[username] = nil
            logger.info("Removed pairing for \(String(data: username, encoding: .utf8)!)")
        case .listPairings:
            // TODO: implement
            return .badRequest
        default:
            logger.info("Unhandled PairingMethod request: \(method)")
            return .badRequest
        }

        let result: PairTagTLV8 = [
            .state: Data(bytes: [PairStep.response.rawValue])
        ]
        return Response(status: .ok, data: encode(result), mimeType: "application/pairing+tlv8")
    }
}
