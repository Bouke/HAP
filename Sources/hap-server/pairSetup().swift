import Foundation
import HTTP
import HKDF

func pairSetup(connection: Connection, request: Request) -> Response {
    guard let body = request.body, let data: PairTagTLV8 = try? decode(body) else { return Response(status: .badRequest) }

    switch PairSetupStep(rawValue: data[.sequence]![0]) {
    case .startRequest?:
        print("<-- B", server.B)
        print("<-- s", salt)

        let result: PairTagTLV8 = [
            .sequence: Data(bytes: [PairSetupStep.startResponse.rawValue]),
            .publicKey: server.B,
            .salt: salt,
        ]
        let response = Response(status: .ok)
        response.headers["Content-Type"] = "application/pairing+tlv8"
        response.body = encode(result)
        return response

    case .verifyRequest?:
        guard let A = data[.publicKey], let M = data[.proof] else {
            return Response(status: .badRequest)
        }

        print("--> A", A)
        print("--> M", M)

        guard let HAMK = try? server.verifySession(A: A, M: M) else {
            return Response(status: .badRequest)
        }

        print("<-- HAMK", HAMK)

        let result: PairTagTLV8 = [
            .sequence: Data(bytes: [PairSetupStep.verifyResponse.rawValue]),
            .proof: HAMK
        ]

        let response = Response(status: .ok)
        response.headers["Content-Type"] = "application/pairing+tlv8"
        response.body = encode(result)
        return response

    case .keyExchangeRequest?:
        guard let encryptedData = data[.encryptedData] else {
            return Response(status: .badRequest)
        }

        let encryptionKey = deriveKey(algorithm: .SHA512, seed: server.sessionKey!, info: "Pair-Setup-Encrypt-Info".data(using: .utf8)!, salt: "Pair-Setup-Encrypt-Salt".data(using: .utf8)!, count: 32)

        guard let plaintext = try? ChaCha20Poly1305(key: encryptionKey, nonce: "PS-Msg05".data(using: .utf8)!)!.decrypt(cipher: encryptedData) else {
            return Response(status: .badRequest)
        }

        guard let data: PairTagTLV8 = try? decode(plaintext) else {
            return Response(status: .badRequest)
        }

        guard let publicKey = data[.publicKey], let username = data[.username], let signatureIn = data[.signature] else {
            return Response(status: .badRequest)
        }

        print("--> username", username, String(data: username, encoding: .utf8)!)
        print("--> public key", publicKey)
        print("--> signature", signatureIn)

        let hashIn = deriveKey(algorithm: .SHA512, seed: server.sessionKey!,
                               info: "Pair-Setup-Controller-Sign-Info".data(using: .utf8)!,
                               salt: "Pair-Setup-Controller-Sign-Salt".data(using: .utf8)!, count: 32) +
            username +
            publicKey

        do {
            try Ed25519.verify(publicKey: publicKey, message: hashIn, signature: signatureIn)
        } catch {
            return Response(status: .badRequest)
        }

        // At this point, the client has successfully verified.
        //TODO: store the pairing (username and publickey of the client)
        device.clients[username] = publicKey

        let hashOut = deriveKey(algorithm: .SHA512, seed: server.sessionKey!,
                                info: "Pair-Setup-Accessory-Sign-Info".data(using: .utf8)!,
                                salt: "Pair-Setup-Accessory-Sign-Salt".data(using: .utf8)!, count: 32) +
            device.identifier.data(using: .utf8)! +
            device.publicKey

        guard let signatureOut = try? Ed25519.sign(privateKey: device.privateKey, message: hashOut) else {
            return Response(status: .badRequest)
        }

        let resultInner: PairTagTLV8 = [
            .username: device.identifier.data(using: .utf8)!,
            .publicKey: device.publicKey,
            .signature: signatureOut
        ]

        print("<-- username", device.identifier)
        print("<-- public key", device.publicKey)
        print("<-- signature", signatureOut)

        guard let encryptor = ChaCha20Poly1305(key: encryptionKey, nonce: "PS-Msg06".data(using: .utf8)!), let encryptedResultInner = try? encryptor.encrypt(message: encode(resultInner)) else {
            return Response(status: .badRequest)
        }

        let resultOuter: PairTagTLV8 = [
            .sequence: Data(bytes: [PairSetupStep.keyExchangeResponse.rawValue]),
            .encryptedData: encryptedResultInner
        ]

        let response = Response(status: .ok)
        response.headers["Content-Type"] = "application/pairing+tlv8"
        response.body = encode(resultOuter)
        return response
        
    case let step: print(request); print(step); print(data)
    }
    
    return Response(status: .badRequest, text: "Not sure what to do here...")
}
