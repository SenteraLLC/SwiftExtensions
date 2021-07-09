//
//  CLLocationExtensions.swift
//  FieldAgent
//
//  Created by Reid Plumbo on 9/22/17.
//  Copyright © 2017 Sentera. All rights reserved.
//

import CoreLocation

public extension CLLocation {
    convenience init(coordinate: CLLocationCoordinate2D, altitude: CLLocationDistance) {
        self.init(coordinate: coordinate, altitude: altitude, horizontalAccuracy: 0.0, verticalAccuracy: 0.0, timestamp: Date(timeIntervalSinceNow: 0))
    }

    @inline(__always)
    func hasEqualCoordinateAndAltitude(to location: CLLocation) -> Bool {
        coordinate == location.coordinate && altitude == location.altitude
    }

    static func invalidLocation() -> CLLocation {
        CLLocation(coordinate: kCLLocationCoordinate2DInvalid, altitude: 0.0)
    }

    func isValid() -> Bool {
        coordinate.isValid()
    }

    func isNull() -> Bool {
        coordinate.isNull()
    }
}
