import Foundation

class PairingsController {
    let device: Device
    public init(device: Device) {
        self.device = device
    }

    func listPairings() -> PairTagTLV8 {
        let pairings = device.configuration.pairings.values
            .map { pairing -> PairTagTLV8 in
                [
                    (.identifier, pairing.identifier),
                    (.publicKey, pairing.publicKey),
                    (.permissions, Data(bytes: [pairing.role.rawValue]))
                ]
            }
            .joined(separator: [(.state, Data(bytes: [PairStep.response.rawValue]))])
            //.flatMap { $0 }
        return [(.state, Data(bytes: [PairStep.response.rawValue]))] + pairings
    }
}
