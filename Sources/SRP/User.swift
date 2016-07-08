//
//  User.swift
//  HAP
//
//  Created by Bouke Haarsma on 30-06-16.
//
//

import Foundation
import CSRP

/**
    A User object is used to prove a user’s identity to a remote Verifier and verifiy that the remote Verifier knows the verification key associated with the user’s password.
 */
public class User {
    internal let boxed: OpaquePointer

    /**
        Instantiates a User object.

        - Parameters:
            - algorithm: (Optional) which algorithm to use
            - ngType: (Optional) which Number Generator (prime) to use
            - username: the user's username
            - password: the user's password
    */
    public init(algorithm: SRP_HashAlgorithm = SRP_SHA1, ngType: SRP_NGType = SRP_NG_2048, username: String, password: String) {
        boxed = srp_user_new(algorithm, ngType, username, password, Int32(strlen(password)), nil, nil)
    }

    /** 
        Return True if authentication succeeded. False otherwise.
    */
    public var isAuthenticated: Bool {
        return srp_user_is_authenticated(boxed) == 1
    }

    /**
        Return the username passed to the constructor.
    */
    public var username: String {
        return String(cString: srp_user_get_username(boxed))
    }

    /**
        Return the session key if authentication succeeded or None if the authentication failed or has not yet completed.
    */
    public var sessionKey: Data {
        var key_length: Int32 = 0
        return Data(bytes: srp_user_get_session_key(boxed, &key_length), count: Int(key_length))
    }

    /**
        Return (username, bytes_A). These should be passed to the constructor of the remote Verifier.
    */
    public func startAuthentication() throws -> (username: String, A: Data){
        var auth_username: UnsafePointer<Int8>? = nil
        var bytes_A: UnsafePointer<UInt8>? = nil
        var len_A: Int32 = 0
        srp_user_start_authentication(boxed, &auth_username, &bytes_A, &len_A)
        guard auth_username != nil && bytes_A != nil else { throw Error.authenticationFailed }
        return (String(cString: auth_username!), Data(bytes: bytes_A!, count: Int(len_A)))
    }

    /**
        Processe the challenge returned by Verifier.challenge on success this method returns M that should be sent to Verifier.verifySession() if authentication failed, it throws.
     */
    public func processChallenge(salt: Data, B: Data) throws -> Data {
        let bytes_s = Array(salt)
        let bytes_B = Array(B)
        var bytes_M: UnsafePointer<UInt8>? = nil
        var len_M: Int32 = 0
        srp_user_process_challenge(boxed, bytes_s, Int32(bytes_s.count), bytes_B, Int32(bytes_B.count), &bytes_M, &len_M)
        guard bytes_M != nil else { throw Error.authenticationFailed }
        return Data(bytes: bytes_M!, count: Int(len_M))
    }

    /**
        Complete the User side of the authentication process. By verifying the HAMK value returned by Verifier.verifySession(). If the authentication succeded isAuthenticated will return True.
     */
    public func verifySession(H_AMK: Data) throws {
        let bytes_H_AMK = Array(H_AMK)
        srp_user_verify_session(boxed, bytes_H_AMK)
        guard isAuthenticated else { throw Error.authenticationFailed }
    }
}
