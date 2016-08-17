import XCTest
import HKDF
import CLibSodium

class Poly1305Chacha20Tests: XCTestCase {
    func test() {
        precondition(sodium_init() != -1)

        let S = Data(hex: "5372b39a6aa13e98cd3eb9c79c9b0dce86d2d193632836f1f1c6e2390e18553d6cf2a6f1852f1c42d9696a1b5ad6676e11d2076d022181b50ed01c7d30540278")!

        let encryptionSalt = "Pair-Setup-Encrypt-Salt".data(using: .utf8)!
        let encryptionInfo = "Pair-Setup-Encrypt-Info".data(using: .utf8)!
        let encryptionKey = deriveKey(algorithm: .SHA512, seed: S, info: encryptionInfo, salt: encryptionSalt, count: 32)

        print("EncryptionKey: ", encryptionKey)

        let encrypted = Data(hex: "c55048655f07166bd853b12de509ecce7f590faf5ff69d14352daf4a162962814f69f9f5604030a3b204e6f7441d1c8e1ff875573e0126513da52ebe6423690ca44f30260d3aa4477e397b210040c1970be41767f631269ca0eb77a3dfb3fd43c0cba81d3f91e7076ee0dee8de70e3ebb4ff8d05a38da137ac15d938bcf861e262eb8c845175999fb2f62294851d7c43f24a5903f66975c7442d")!
        let message = Data(encrypted[0..<encrypted.endIndex-16])
        let mac = Data(encrypted[encrypted.endIndex-16..<encrypted.endIndex])
        print("message:", message)
        print("mac:", mac)

        // print("decrypted:", Data(try! ChaCha20(key: Array(encryptionKey), iv: Array("PS-Msg05".utf8))!.decrypt(Array(message))))
        // print("authenticate result:", Data(try! Authenticator.Poly1305(key: Array(encryptionKey)).authenticate(Array(message))))

        var plaintext = Data(count: message.count)

        // let r = plaintext.withUnsafeMutableBytes { (plaintext: UnsafeMutablePointer<UInt8>) in
        //     message.withUnsafeBytes { (ciphertext: UnsafePointer<UInt8>) in
        //         mac.withUnsafeBytes { (mac: UnsafePointer<UInt8>) in
        //             encryptionKey.withUnsafeBytes { (key: UnsafePointer<UInt8>) in
        //                 crypto_aead_chacha20poly1305_decrypt_detached(
        //                     plaintext, // plaintext
        //                     nil, // nsec
        //                     ciphertext, UInt64(message.count), // cipher -- message
        //                     mac, // mac
        //                     nil, 0,
        //                     "PS-Msg05",
        //                     key) // encryptionKey
        //             }
        //         }
        //     }
        // }

        let r = plaintext.withUnsafeMutableBytes { (plaintext: UnsafeMutablePointer<UInt8>) in
            encrypted.withUnsafeBytes { (ciphertext: UnsafePointer<UInt8>) in
                encryptionKey.withUnsafeBytes { (key: UnsafePointer<UInt8>) in
                    crypto_secretbox_open_easy(plaintext, ciphertext, UInt64(encrypted.count), "PS-Msg05", key)
                }
            }
        }

        // print(mac.count, crypto_aead_chacha20poly1305_IETF_ABYTES, crypto_aead_chacha20poly1305_ABYTES)
        // print("PS-Msg05".utf8.count, crypto_aead_chacha20poly1305_IETF_NPUBBYTES, crypto_aead_chacha20poly1305_NPUBBYTES)
        // print(encryptionKey.count, crypto_aead_chacha20poly1305_IETF_KEYBYTES, crypto_aead_chacha20poly1305_KEYBYTES)
        // print(16, crypto_aead_chacha20poly1305_IETF_ABYTES, crypto_aead_chacha20poly1305_ABYTES)

        // let r = plaintext.withUnsafeMutableBytes { (plaintext: UnsafeMutablePointer<UInt8>) in
        //     encrypted.withUnsafeBytes { (ciphertext: UnsafePointer<UInt8>) in
        //         encryptionKey.withUnsafeBytes { (key: UnsafePointer<UInt8>) in
        //             crypto_aead_chacha20poly1305_decrypt(
        //                 plaintext, nil, // m -- plaintext
        //                 nil, // nsec
        //                 ciphertext, UInt64(message.count), // cipher -- message
        //                 nil, 0,
        //                 "PS-Msg05",
        //                 key) // encryptionKey
        //         }
        //     }
        // }

        print("r:", r)
        print("plaintext", plaintext)
    }
}
