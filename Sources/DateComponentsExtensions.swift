//
//  DateComponentsExtensions.swift
//  SwiftExtensions
//
//  Created by Logan Cautrell on 1/2/20.
//  Copyright © 2020 Sentera. All rights reserved.
//

import Foundation

public extension DateComponents {
    static func yearMonthDayComponents(from date: Date) -> DateComponents {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.day, .month, .year], from: date)
        components.calendar = calendar
        return components
    }

    static func monthDayComponents(from date: Date) -> DateComponents {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.month, .year], from: date)
        components.calendar = calendar
        return components
    }
}
