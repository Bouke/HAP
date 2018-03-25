import Foundation
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap.endpoints.pairings")

func pairings(device: Device) -> Application {
    let controller = PairingsController(device: device)

    return { connection, request in
        var body = Data()
        guard request.method == "POST" else {
            return .methodNotAllowed
        }
        guard
            (try? request.readAllData(into: &body)) != nil,
            let data: PairTagTLV8 = try? decode(body),
            data[.state]?[0] == PairStep.request.rawValue,
            let method = data[.pairingMethod].flatMap({ PairingMethod(rawValue: $0[0]) })
            else {
                return .badRequest
        }

        guard connection.pairing?.role == .admin else {
            logger.warning("Permission denied (non-admin) to update pairing data: \(data), method: \(method)")
            let result: PairTagTLV8 = [
                (.state, Data(bytes: [PairStep.response.rawValue])),
                (.error, Data(bytes: [PairError.authenticationFailed.rawValue]))
            ]
            return Response(status: .ok, data: encode(result), mimeType: "application/pairing+tlv8")
        }

        logger.debug("Updating pairings data: \(data), method: \(method)")

        switch method {
        case .addPairing:
            guard let username = data[.identifier],
                let publicKey = data[.publicKey],
                let permissions = data[.permissions]?.first,
                let role = Pairing.Role(rawValue: permissions) else {
                    return .badRequest
            }
            device.add(pairing: Pairing(identifier: username, publicKey: publicKey, role: role))
            logger.info("Added \(role) pairing for \(String(data: username, encoding: .utf8)!)")
        case .removePairing:
            guard let username = data[.identifier] else {
                return .badRequest
            }
            device.remove(pairingWithIdentifier: username)
            logger.info("Removed pairing for \(String(data: username, encoding: .utf8)!)")
        case .listPairings:
            logger.debug("Listing parings")
            let result = controller.listPairings()
            return Response(status: .ok, data: encode(result), mimeType: "application/pairing+tlv8")
        default:
            logger.info("Unhandled PairingMethod request: \(method)")
            return .badRequest
        }

        let result: PairTagTLV8 = [
            (.state, Data(bytes: [PairStep.response.rawValue]))
        ]
        return Response(status: .ok, data: encode(result), mimeType: "application/pairing+tlv8")
    }
}
