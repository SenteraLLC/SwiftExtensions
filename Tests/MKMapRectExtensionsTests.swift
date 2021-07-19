//
//  MKMapRectExtensionsTests.swift
//  FieldAgentTests
//
//  Created by Logan Cautrell on 10/11/18.
//  Copyright © 2018 Sentera. All rights reserved.
//

import MapKit
@testable import SwiftExtensions
import XCTest

class MKMapRectExtensionsTests: XCTestCase {

    func testMapRectForAnnotations_NoAnnotations() {
        let annotations: [MKAnnotation] = []
        
        let rect = MKMapRect.mapRect(for: annotations)
        XCTAssertEqual(rect, MKMapRect.null)
        XCTAssertNotEqual(rect, MKMapRect.world)
    }

    func testMapRectForAnnotations_OneAnnotations() {
        let annotations: [MKAnnotation] = [
            MockAnnotation(latitude: 1.0, longitude: 1.0)
        ]
        
        let rect = MKMapRect.mapRect(for: annotations)
        XCTAssertNotEqual(rect, MKMapRect.null)
        XCTAssertNotEqual(rect, MKMapRect.world)
        XCTAssertNotEqual(rect.height, 0.0)
        XCTAssertNotEqual(rect.width, 0.0)
    }
    
    func testMapRectForAnnotations_ThreeAnnotations() {
        let annotations: [MKAnnotation] = [
            MockAnnotation(latitude: 1.0, longitude: 1.0),
            MockAnnotation(latitude: 2.0, longitude: 1.0),
            MockAnnotation(latitude: 1.0, longitude: 2.0)
        ]
        
        let rect = MKMapRect.mapRect(for: annotations)
        XCTAssertNotEqual(rect, MKMapRect.null)
        XCTAssertNotEqual(rect, MKMapRect.world)
        XCTAssertNotEqual(rect.height, 0.0)
        XCTAssertNotEqual(rect.width, 0.0)
    }
}

class MockAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D

    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        super.init()
    }
}
