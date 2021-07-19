//
//  StringExtensionsTests.swift
//  SwiftExtensionsTests
//
//  Created by Bryan Rahn on 3/4/20.
//  Copyright © 2020 Sentera. All rights reserved.
//

import CryptoKit
import Foundation
@testable import SwiftExtensions
import XCTest

// CryptoKit.Digest utils
@available(iOS 13.0, *)
extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }

    var hexStr: String {
        bytes.map { String(format: "%02X", $0) }.joined()
    }
}

class StringExtensionsTests: XCTestCase {

    /// Ensure the non-iOS 13 version of SHA256 is equivalent to iOS 13 CryptoKit version
    func testSHA256() {
        let senteraID = "vkuk9ja_US_7yqcJohnDow_CV_prod_f844446_200204_170541"
        guard let data = senteraID.data(using: .utf8) else {
            XCTFail("Unable to convert string to data")
            return
        }

        if #available(iOS 13.0, *) {
            let digest = SHA256.hash(data: data)
            XCTAssertEqual(digest.hexStr, senteraID.sha256)
        } else {
            XCTFail("iOS 13 must be used to test SHA256")
        }
    }
}
