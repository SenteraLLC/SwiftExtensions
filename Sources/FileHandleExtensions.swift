//
//  FileHandleExtensions.swift
//  SwiftExtensions
//
//  Created by Logan Cautrell on 7/6/21.
//  Copyright © 2021 Sentera. All rights reserved.
//

import Foundation

public extension FileHandle {
    func safeWrite(data: Data) throws {
        if #available(iOS 13.4, *) {
            try write(contentsOf: data)
        } else {
            write(data)
        }
    }

    func safeSeekToEnd() throws {
        if #available(iOS 13.4, *) {
            try seekToEnd()
        } else {
            seekToEndOfFile()
        }
    }

    func safeReadToEnd() throws -> Data? {
        if #available(iOS 13.4, *) {
            return try readToEnd()
        } else {
            return readDataToEndOfFile()
        }
    }
}
