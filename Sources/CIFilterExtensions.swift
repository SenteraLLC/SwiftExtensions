//
//  CIFilterExtensions.swift
//  FieldAgent
//
//  Created by Logan Cautrell on 12/11/18.
//  Copyright © 2018 Sentera. All rights reserved.
//

import CoreImage

public extension CIFilter {

    static func filter(named name: String) -> CIFilter {
        guard let filter = CIFilter(name: name) else {
            assertionFailure("unable to build \(name)")
            return CIFilter()
        }
        return filter
    }
}
