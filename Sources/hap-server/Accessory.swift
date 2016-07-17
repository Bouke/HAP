//
//  Accessory.swift
//  HAP
//
//  Created by Bouke Haarsma on 17-07-16.
//
//

import Foundation
import CLibSodium
import CommonCrypto

class Client {
    let username: String
    let publicKey: Data

    init(username: String, publicKey: Data) {
        self.username = username
        self.publicKey = publicKey
    }
}

class Accessory {
    let name: String

    init(name: String) {
        self.name = name
    }
}

class Device {
    let name: String
    let publicKey: Data
    let privateKey: Data
    let pin: String

    convenience init(name: String, pin: String) {
        let (pk, sk) = Ed25519.generateSignKeypair()
        self.init(name: name, pin: pin, publicKey: pk, privateKey: sk)
    }

    init(name: String, pin: String, publicKey: Data, privateKey: Data) {
        self.name = name
        self.pin = pin
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
}
