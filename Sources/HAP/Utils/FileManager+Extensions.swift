//
//  FileManager+Extensions.swift
//  HAP
//
//  Created by Bouke Haarsma on 19-07-16.
//
//

import Foundation

extension FileManager {
    func directoryExists(atPath path: String) -> Bool {
        var isDirectory = ObjCBool(false)
        _ = fileExists(atPath: path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
}
