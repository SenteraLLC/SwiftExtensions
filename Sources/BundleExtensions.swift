//
//  BundleExtensions.swift
//  FieldAgent
//
//  Created by Bryan Rahn on 8/23/17.
//  Copyright © 2017 Sentera. All rights reserved.
//

import Foundation

public extension Bundle {
    static var versionShort: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    static var version: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }

    static var versionDescription: String {
        "\(Bundle.versionShort ?? "Unknown")(\(Bundle.version ?? "Unknown"))"
    }

    static var quickStitchFramework: Bundle? {
        Bundle(identifier: "com.sentera.QuickStitchFramework")
    }
}
