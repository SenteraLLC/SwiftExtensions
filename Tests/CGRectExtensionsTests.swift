//
//  CGRectExtensionsTests.swift
//  SwiftExtensionsTests
//
//  Created by Logan Cautrell on 10/1/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

@testable import SwiftExtensions
import XCTest

class CGRectExtensionsTests: XCTestCase {

    func testDistanceToCenterIsZero() {
        let rect = CGRect(x: 10.0, y: 10.0, width: 10.0, height: 10.0)
        let point = CGPoint(x: 15.0, y: 15.0)
        XCTAssertEqual(rect.distanceFromCenter(to: point), 0.0)
    }

    func testDistanceToCenterIsBelow() {
        let rect = CGRect(x: 10.0, y: 10.0, width: 10.0, height: 10.0)
        let point = CGPoint(x: 15.0, y: 20.0)
        XCTAssertEqual(rect.distanceFromCenter(to: point), 5.0)
    }

    func testDistanceToCenterIsAbove() {
        let rect = CGRect(x: 10.0, y: 10.0, width: 10.0, height: 10.0)
        let point = CGPoint(x: 15.0, y: 10.0)
        XCTAssertEqual(rect.distanceFromCenter(to: point), 5.0)
    }

    func testDistanceToCenterIsLeft() {
        let rect = CGRect(x: 10.0, y: 10.0, width: 10.0, height: 10.0)
        let point = CGPoint(x: 20.0, y: 15.0)
        XCTAssertEqual(rect.distanceFromCenter(to: point), 5.0)
    }

    func testDistanceToCenterIsRight() {
        let rect = CGRect(x: 10.0, y: 10.0, width: 10.0, height: 10.0)
        let point = CGPoint(x: 10.0, y: 15.0)
        XCTAssertEqual(rect.distanceFromCenter(to: point), 5.0)
    }
}
