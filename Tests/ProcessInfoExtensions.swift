//
//  ProcessInfoExtensions.swift
//  SwiftExtensions
//
//  Created by Logan Cautrell on 8/25/20.
//  Copyright © 2020 Sentera. All rights reserved.
//

import Foundation

public extension ProcessInfo {
    static func isRunningTests() -> Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        #else
        return false
        #endif
    }
}
