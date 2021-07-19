//
//  DateFormatterExtensions.swift
//  FieldAgent
//
//  Created by Bryan Rahn on 12/6/17.
//  Copyright © 2017 Sentera. All rights reserved.
//

import Foundation

public extension DateFormatter {
    
    // MARK: - Preset formatters
    static let dayOrdinalFormatter: DateFormatter = .formatterForFormatWithCurrentLocale(format: "EEEEE")
    static let dayFormatter: DateFormatter = .formatterForFormatWithCurrentLocale(format: "d")
    static let shortTimeFormatter: DateFormatter = .dateFormatterCurrentLocale(dateStyle: .none, timeStyle: .short)
    static let shortDateFormatter: DateFormatter = .dateFormatterCurrentLocale(dateStyle: .short, timeStyle: .none)
    static let mediumDateFormatter: DateFormatter = .dateFormatterCurrentLocale(dateStyle: .medium, timeStyle: .none)
    static let longDateFormatter: DateFormatter = .dateFormatterCurrentLocale(dateStyle: .long, timeStyle: .none)
    static let longDateTimeFormatter: DateFormatter = .dateFormatterCurrentLocale(dateStyle: .long, timeStyle: .long)
    static let fullDateFormatter: DateFormatter = .formatterForFormatWithCurrentLocale(format: "yyyy-MM-dd h.mm.ss a zzz")
    static let yearMonthDayHourMinuteSecondDateFormatter: DateFormatter = .formatterForFormatWithCurrentLocale(format: "yyyy_MM_dd_hh_mm_ss")
    static let liveModeVideoFileDateFormatter: DateFormatter = .formatterForFormatWithCurrentLocale(format: "yyyy_MM_dd_hh_mm_ss")
    static let dataAnalyticsFileDateFormatter: DateFormatter = .formatterForFormatWithCurrentLocale(format: "yyyy_MM_dd_hh_mm_ss")
    static let quickStitchMosaicDateFormatter: DateFormatter = .formatterForFormatWithCurrentLocale(format: "yyyy_MM_dd_HH_mm_ss")

    // MARK: - ISO 8601
    static let iso8601Formatter = ISO8601DateFormatter()
    static let ios8601YearMonthDayFormatter: DateFormatter = .formatterForFormatWithCurrentLocale(format: "yyyy-MM-dd")
    static let ios8601MMddyyyyFormatter: DateFormatter = .formatterForFormatWithCurrentLocale(format: "MM-dd-yyyy")
    static let ios8601MonthDayFormatter: DateFormatter = .formatterForFormatWithCurrentLocale(format: "MM-dd")
    static let ios8601YearFormatter: DateFormatter = .formatterForFormatWithCurrentLocale(format: "yyyy")
    static let iso8601FormatterLocalWithFractionalSeconds: ISO8601DateFormatter = iso8601DateFormatterWithFractionalSeconds()

    // MARK: - Helper functions
    private static func dateFormatterCurrentLocale(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> DateFormatter {
        let formatter = DateFormatter.gregorianCurrentLocaleDateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter
    }
    
    private static func formatterForFormatWithCurrentLocale(format: String) -> DateFormatter {
        let formatter = DateFormatter.gregorianCurrentLocaleDateFormatter()
        formatter.dateFormat = format
        return formatter
    }
    
    private static func gregorianCurrentLocaleDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale.current
        return formatter
    }

    private static func iso8601DateFormatterWithFractionalSeconds() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.update(with: .withFractionalSeconds)
        formatter.timeZone = TimeZone.current
        return formatter
    }
}

// MARK: - US Locale formatters

public extension DateFormatter {
    static let mediumDateShortTimeDateFormatter: DateFormatter = .dateFormatterUSLocale(dateStyle: .medium, timeStyle: .short)
    static let noDateLongTimeDateFormatter: DateFormatter = .dateFormatterUSLocale(dateStyle: .none, timeStyle: .long)

    private static func dateFormatterUSLocale(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> DateFormatter {
        let formatter = DateFormatter.gregorianUSLocaleDateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter
    }
    
    private static func gregorianUSLocaleDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }
}
