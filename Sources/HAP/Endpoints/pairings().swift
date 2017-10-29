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
            let _ = try? request.readAllData(into: &body),
            let data: PairTagTLV8 = try? decode(body),
            data[.sequence]?[0] == PairStep.request.rawValue,
            let method = data[.pairingMethod].flatMap({PairingMethod(rawValue: $0[0])}),
            let username = data[.username]
            else {
                return .badRequest
        }
        logger.debug("Updating pairings data: \(data), method: \(method)")

        switch method {
        case .add:
            guard let publicKey = data[.publicKey] else {
                return .badRequest
            }
            device.pairings[username] = publicKey
            logger.info("Added pairing for \(String(data: username, encoding: .utf8)!)")
        case .delete:
            device.pairings[username] = nil
            logger.info("Removed pairing for \(String(data: username, encoding: .utf8)!)")
        default: return .badRequest
        }

        let result: PairTagTLV8 = [
            .sequence: Data(bytes: [PairStep.response.rawValue])
        ]
        return Response(status: .ok, data: encode(result), mimeType: "application/pairing+tlv8")
    }
}
