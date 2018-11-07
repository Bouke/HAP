//
//  Socket+forceClose.swift
//  HAP
//
//  Created by Guy Brooker on 10/10/2018.
//

import Foundation
import Socket

#if os(macOS) || os(iOS) || os(tvOS)
import Darwin
#elseif os(Linux)
import Glibc
#endif

extension Socket {

    // Avoid race conditions in BlueSocket when closing a socket from another
    // thread by closing the sockets file descriptor using system calls.
    //
    // Assumes socket is being listened to and is connected
    static func forceClose(socketfd fd: Int32) {
        #if os(Linux)
        _ = Glibc.shutdown(fd, Int32(SHUT_RDWR))
        _ = Glibc.close(fd)
        #else
        _ = Darwin.shutdown(fd, Int32(SHUT_RDWR))
        _ = Darwin.close(fd)
        #endif
    }
}
