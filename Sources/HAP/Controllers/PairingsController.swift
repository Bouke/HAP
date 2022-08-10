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
                    (.permissions, Data([pairing.role.rawValue]))
                ]
            }
            .joined(separator: [(.state, Data([PairStep.response.rawValue]))])
            // .flatMap { $0 }
        return [(.state, Data([PairStep.response.rawValue]))] + pairings
    }
}
