import Foundation
import HTTP

class Delegate: NSObject, NetServiceDelegate, StreamDelegate {
    var server: Server

    init(application: Application) {
        server = Server(application: application)
    }

    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("didNotPublish", errorDict)
        abort()
    }

    func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: NSOutputStream) {
        server.accept(inputStream: inputStream, outputStream: outputStream)
    }
}

func identifier() -> String {
    return (1...6).map({ _ in String(arc4random() & 255, radix: 16, uppercase: false) }).joined(separator: ":")
}

func root(request: Request) -> Response {
    return Response(status: .OK, text: "Hello, <b>Gib</b>")
}

func identify(request: Request) -> Response {
    //TODO: call accessory's identify callback
    return Response(status: .OK, text: "Got identified")
}


import CLibSodium
import COpenSSL

//print(sodium_init())

var client_secretkey = Data(count: Int(crypto_box_SECRETKEYBYTES))
var client_publickey = Data(count: Int(crypto_box_PUBLICKEYBYTES))
//var client_secretkey = Data(bytes: [UInt8](repeating: 0, count: Int(crypto_box_SECRETKEYBYTES)))
//var client_publickey = Data(bytes: [UInt8](repeating: 0, count: Int(crypto_box_PUBLICKEYBYTES)))

client_secretkey.withUnsafeMutableBytes { secret in
    randombytes_buf(secret, client_secretkey.count)
}

_ = client_secretkey.withUnsafeMutableBytes { secret in
    client_publickey.withUnsafeMutableBytes { pub in
        crypto_scalarmult_base(pub, secret)
    }
}

import CSRP
import SRP

let username = "Pair-Setup"
let password = "001-02-003"

import Bignum
import CommonCrypto

var salt = generateRandomBytes(count: 16)

let group = Group.N3072

/* Create a salt+verification key for the user's password. The salt and
 * key need to be computed at the time the user's password is set and
 * must be stored by the server-side application for use during the
 * authentication process.
 */
//let (salt, verificationKey) = try! createSaltedVerificationKey(algorithm: SRP_SHA512, ngType: SRP_NG_3072, username: username, password: password)
let verificationKey = createSaltedVerificationKey(username: username, password: password, salt: salt, group: group, alg: .SHA512)

let server = Server(group: group, alg: .SHA512, salt: salt, username: username, verificationKey: verificationKey, secret: generateRandomBytes(count: 32))

//let ESC = "\u{001B}"
//let CSI = "\(ESC)["
//print("\(CSI)30;47m                      \(CSI)0m")
//print("\(CSI)30;47m    ┌────────────┐    \(CSI)0m")
//print("\(CSI)30;47m    | 001-02-003 |    \(CSI)0m")
//print("\(CSI)30;47m    └────────────┘    \(CSI)0m")
//print("\(CSI)30;47m                      \(CSI)0m")

//print(client_secretkey, client_publickey)

func pairSetup(request: Request) -> Response {
    guard let body = request.body else { return Response(status: .BadRequest) }
    let data = decode(body)
    print(request)
    print("input", data)

    switch PairSetupStep(rawValue: UInt8(data: data[PairTag.sequence.rawValue]!)) {
    case .startRequest?:
        let result: TLV8 = [
            PairTag.sequence.rawValue: Data(bytes: [PairSetupStep.startResponse.rawValue]),
            PairTag.publicKey.rawValue: server.B,
            PairTag.salt.rawValue: salt,
        ]
        let response = Response(status: .OK)
        response.headers["Content-Type"] = "application/pairing+tlv8"
        response.body = encode(result)
        return response

    case .verifyRequest?:
        let A = data[PairTag.publicKey.rawValue]
        let M = data[PairTag.proof.rawValue]

        print(A!.count, A!)
        print(M!.count, M!)

        let HAMK = try! server.verifySession(A: A!, M: M!)

        let result: TLV8 = [
            PairTag.sequence.rawValue: Data(bytes: [PairSetupStep.verifyResponse.rawValue]),
            PairTag.proof.rawValue: HAMK
        ]

        let response = Response(status: .OK)
        response.headers["Content-Type"] = "application/pairing+tlv8"
        response.body = encode(result)
        return response

    case .keyExchangeRequest?:
        break

    case let step: print(request); print(step)
    }

    return Response(status: .BadRequest, text: "Not sure what to do here...")
}

let router = Router(routes: [
    ("/", root),
    ("/identify", identify),
    ("/pair-setup", pairSetup),
])

let delegate = Delegate(application: router.application)

let service = NetService(domain: "local.", type: "_hap._tcp.", name: "Switch", port: 8000)
let config: [String: Data] = [
    "id": identifier().data(using: .utf8)!, // identifier
    "c#": "3".data(using: .utf8)!, // version
    "s#": "1".data(using: .utf8)!, // state
    "sf": "1".data(using: .utf8)!, // discoverable
    "ff": "0".data(using: .utf8)!, // mfi compliant
    "md": "Switch".data(using: .utf8)!, // name
    "ci": "8".data(using: .utf8)!, // category identifier -- switch
]

//exit(0)


service.setTXTRecord(NetService.data(fromTXTRecord: config))
service.delegate = delegate
service.publish(options: [.listenForConnections])


print(service.port)

withExtendedLifetime((delegate, service)) {
    RunLoop.current.run()
}



// post /identify -> ??

// pair
// post /pair-setup
// enter code
// post /pair-setup -> fail, try again
// enter code
// post /pair-setup -> succeeds, multiple posts to here
// post /pair-verify -> ?
// GET /accessories
// POST /pairings method ADD
// paired

// setup (?)
//GET /characteristics


// unpair

// post /pairings method DELETE -> unpair
// post /pair-verify -> ??
