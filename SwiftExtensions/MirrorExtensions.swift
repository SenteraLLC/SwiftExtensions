//
//  MirrorExtensions.swift
//  SwiftExtensions
//
//  Copyright © 2021 Sentera. All rights reserved.
//

import Foundation

public extension Mirror {
    static func isEmpty(object: Any) -> Bool {
        let mirror = Mirror(reflecting: object)
        for child in mirror.children {
            guard case Optional<Any>.none = child.value else {
                return false
            }
        }
        return true
    }
}
