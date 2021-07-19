//
//  URLExtensions.swift
//  SwiftExtensions
//
//  Created by Logan Cautrell on 6/2/21.
//  Copyright © 2021 Sentera. All rights reserved.
//

import Foundation

public extension URL {
    func accessSecurityScopedResource(work: () -> Bool) -> Bool {
        let isSecurityScoped = startAccessingSecurityScopedResource()
        defer {
            if isSecurityScoped {
                stopAccessingSecurityScopedResource()
            }
        }
        return work()
    }
}
