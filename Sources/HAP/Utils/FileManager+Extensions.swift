//
//  FileManager+Extensions.swift
//  HAP
//
//  Created by Bouke Haarsma on 19-07-16.
//
//

import Foundation

extension FileManager {
    #if os(macOS)
        func directoryExists(atPath path: String) -> Bool {
            var isDirectory = ObjCBool(false)
            _ = fileExists(atPath: path, isDirectory: &isDirectory)
            return isDirectory.boolValue
        }
    #elseif os(Linux)
        func directoryExists(atPath path: String) -> Bool {
            var isDirectory = false
            _ = fileExists(atPath: path, isDirectory: &isDirectory)
            return isDirectory
        }
    #endif
}
