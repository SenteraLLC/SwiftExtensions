//
//  IntExtensions.swift
//  SwiftExtensions
//
//  Created by Logan Cautrell on 7/11/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import Foundation

public extension Int {
    func ordinal() -> String? {
        NumberFormatter.ordinalFormatter().string(from: NSNumber(value: self))
    }
}
