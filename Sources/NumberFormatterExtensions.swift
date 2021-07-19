//
//  NumberFormatterExtensions.swift
//  SwiftExtensions
//
//  Created by Logan Cautrell on 7/11/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import Foundation

public extension NumberFormatter {
    static func ordinalFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }

    static func percentageFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter
    }
}
