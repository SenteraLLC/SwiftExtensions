//
//  MKMapPointExtensions.swift
//  SwiftExtensions
//
//  Created by Logan Cautrell on 6/17/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import MapKit

public extension MKMapPoint {
    func heading(to: MKMapPoint) -> Double {
        let y1 = self.y.degToRad()
        let x1 = self.x.degToRad()
        let y2 = to.y.degToRad()
        let x2 = to.x.degToRad()
        return atan2(y2 - y1, x2 - x1).radToDeg()
    }

    func isValid() -> Bool {
        coordinate.isValid()
    }

    static func centerOf(topLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D) -> MKMapPoint? {
        guard topLeft.isValid() && bottomRight.isValid() else {
            return nil
        }
        return MKMapPoint(
            CLLocationCoordinate2D(latitude: (topLeft.latitude + bottomRight.latitude) / 2.0,
                                   longitude: (topLeft.longitude + bottomRight.longitude) / 2.0))
    }
}
