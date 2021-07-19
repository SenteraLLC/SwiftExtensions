//
//  MKCoordinateRegionExtensionsTests.swift
//  FieldAgentTests
//
//  Created by Logan Cautrell on 10/11/18.
//  Copyright © 2018 Sentera. All rights reserved.
//

import MapKit
@testable import SwiftExtensions
import XCTest

class MKCoordinateRegionExtensionsTests: XCTestCase {

    func testMapRect_CenterWithNoSpan() {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 123.0, longitude: 123.0),
                                        span: MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 0.0))
        let rect = region.mapRect()
        XCTAssertNotEqual(rect.minX, 0.0)
        XCTAssertNotEqual(rect.minY, 0.0)
        XCTAssertEqual(rect.width, 0.0)
        XCTAssertEqual(rect.height, 0.0)
    }

    func testMapRect_CenterWithSpan() {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 123.0, longitude: 123.0),
                                        span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0))
        let rect = region.mapRect()
        XCTAssertNotEqual(rect.minX, 0.0)
        XCTAssertNotEqual(rect.minY, 0.0)
        XCTAssertNotEqual(rect.width, 0.0)
        XCTAssertNotEqual(rect.height, 0.0)
    }
}
