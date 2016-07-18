import Foundation
import HTTP
import HKDF

func pairSetup(request: Request) -> Response {
    guard let body = request.body, let data = try? decode(body) else { return Response(status: .BadRequest) }

    switch PairSetupStep(rawValue: UInt8(data: data[Tag.sequence.rawValue]!)) {
    case .startRequest?:
        print("<-- B", server.B)
        print("<-- s", salt)

        let result: TLV8 = [
            Tag.sequence.rawValue: Data(bytes: [PairSetupStep.startResponse.rawValue]),
            Tag.publicKey.rawValue: server.B,
            Tag.salt.rawValue: salt,
        ]
        let response = Response(status: .OK)
        response.headers["Content-Type"] = "application/pairing+tlv8"
        response.body = encode(result)
        return response

    case .verifyRequest?:
        guard let A = data[Tag.publicKey.rawValue], let M = data[Tag.proof.rawValue] else {
            return Response(status: .BadRequest)
        }

        print("--> A", A)
        print("--> M", M)

        guard let HAMK = try? server.verifySession(A: A, M: M) else {
            return Response(status: .BadRequest)
        }

        print("<-- HAMK", HAMK)

        let result: TLV8 = [
            Tag.sequence.rawValue: Data(bytes: [PairSetupStep.verifyResponse.rawValue]),
            Tag.proof.rawValue: HAMK
        ]

        let response = Response(status: .OK)
        response.headers["Content-Type"] = "application/pairing+tlv8"
        response.body = encode(result)
        return response

    case .keyExchangeRequest?:
        guard let encryptedData = data[Tag.encryptedData.rawValue] else {
            return Response(status: .BadRequest)
        }

        let encryptionKey = deriveKey(algorithm: .SHA512, seed: server.sessionKey!, info: "Pair-Setup-Encrypt-Info".data(using: .utf8)!, salt: "Pair-Setup-Encrypt-Salt".data(using: .utf8)!, count: 32)

        guard let plaintext = try? ChaCha20Poly1305(key: encryptionKey, nonce: "PS-Msg05".data(using: .utf8)!)!.decrypt(cipher: encryptedData) else {
            return Response(status: .BadRequest)
        }

        guard let data = try? decode(plaintext) else {
            return Response(status: .BadRequest)
        }

        guard let publicKey = data[Tag.publicKey.rawValue], let username = data[Tag.username.rawValue], let signatureIn = data[Tag.signature.rawValue] else {
            return Response(status: .BadRequest)
        }

        print("--> username", username, String(data: username, encoding: .utf8)!)
        print("--> public key", publicKey)
        print("--> signature", signatureIn)

        let hashIn = deriveKey(algorithm: .SHA512, seed: server.sessionKey!,
                               info: "Pair-Setup-Controller-Sign-Info".data(using: .utf8)!,
                               salt: "Pair-Setup-Controller-Sign-Salt".data(using: .utf8)!, count: 32) +
            username +
            publicKey

        print("hashOut", hashIn, hashIn.count)

        do {
            try Ed25519.verify(publicKey: publicKey, message: hashIn, signature: signatureIn)
        } catch {
            return Response(status: .BadRequest)
        }

        // At this point, the client has successfully verified.
        //TODO: store the pairing (username and publickey of the client)

        let hashOut = deriveKey(algorithm: .SHA512, seed: server.sessionKey!,
                                info: "Pair-Setup-Accessory-Sign-Info".data(using: .utf8)!,
                                salt: "Pair-Setup-Accessory-Sign-Salt".data(using: .utf8)!, count: 32) +
            device.identifier.data(using: .utf8)! +
            device.publicKey

        guard let signatureOut = try? Ed25519.sign(privateKey: device.privateKey, message: hashOut) else {
            return Response(status: .BadRequest)
        }

        let resultInner: TLV8 = [
            Tag.username.rawValue: device.identifier.data(using: .utf8)!,
            Tag.publicKey.rawValue: device.publicKey,
            Tag.signature.rawValue: signatureOut
        ]

        print("<-- username", device.identifier)
        print("<-- public key", device.publicKey)
        print("<-- signature", signatureOut)

        guard let encryptor = ChaCha20Poly1305(key: encryptionKey, nonce: "PS-Msg06".data(using: .utf8)!), let encryptedResultInner = try? encryptor.encrypt(message: encode(resultInner)) else {
            return Response(status: .BadRequest)
        }

        print("encrypted", encryptedResultInner)

        let resultOuter: TLV8 = [
            Tag.sequence.rawValue: Data(bytes: [PairSetupStep.keyExchangeResponse.rawValue]),
            Tag.encryptedData.rawValue: encryptedResultInner
        ]

        print("result", encode(resultOuter))

        let response = Response(status: .OK)
        response.headers["Content-Type"] = "application/pairing+tlv8"
        response.body = encode(resultOuter)
        return response
        
    case let step: print(request); print(step); print(data)
    }
    
    return Response(status: .BadRequest, text: "Not sure what to do here...")
}
