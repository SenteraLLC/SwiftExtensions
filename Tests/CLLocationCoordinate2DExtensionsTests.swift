//
//  CLLocationCoordinate2DExtensionsTests.swift
//  FieldAgentTests
//
//  Created by Logan Cautrell on 4/11/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import CoreLocation
@testable import SwiftExtensions
import XCTest

class CLLocationCoordinate2DExtensionsTests: XCTestCase {

    func testIsEqual() {
        let location1 = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
        let location2 = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
        XCTAssertEqual(location1, location2)
    }

    func testLatNotEqual() {
        let location1 = CLLocationCoordinate2D(latitude: 2.0, longitude: 1.0)
        let location2 = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
        XCTAssertNotEqual(location1, location2)
    }

    func testLonNotEqual() {
        let location1 = CLLocationCoordinate2D(latitude: 1.0, longitude: 2.0)
        let location2 = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)
        XCTAssertNotEqual(location1, location2)
    }

    // latitude in degrees is -90 and +90
    // longitude is in the range -180 and +180
    func testIsValid() {
        XCTAssertTrue(CLLocationCoordinate2D(latitude: -90.0, longitude: -180.0).isValid())
        XCTAssertTrue(CLLocationCoordinate2D(latitude: 90.0, longitude: -180.0).isValid())
        XCTAssertTrue(CLLocationCoordinate2D(latitude: -90.0, longitude: 180.0).isValid())
        XCTAssertTrue(CLLocationCoordinate2D(latitude: 90.0, longitude: 180.0).isValid())
    }

    // latitude in degrees is -90 and +90
    // longitude is in the range -180 and +180
    func testNotIsValid() {
        XCTAssertFalse(CLLocationCoordinate2D(latitude: -90.1, longitude: -180.1).isValid())
        XCTAssertFalse(CLLocationCoordinate2D(latitude: 90.1, longitude: -180.1).isValid())
        XCTAssertFalse(CLLocationCoordinate2D(latitude: -90.1, longitude: 180.1).isValid())
        XCTAssertFalse(CLLocationCoordinate2D(latitude: 90.1, longitude: 180.1).isValid())
    }
}
