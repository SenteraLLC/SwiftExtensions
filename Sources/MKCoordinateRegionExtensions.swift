//
//  MKCoordinateRegionExtensions.swift
//  FieldAgent
//
//  Created by Bryan Rahn on 10/17/17.
//  Copyright © 2017 Sentera. All rights reserved.
//

import MapKit

public extension MKCoordinateRegion {

    var topLeft: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: center.latitude + (span.latitudeDelta/2),
                               longitude: center.longitude - (span.longitudeDelta/2))
    }

    var bottomRight: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: center.latitude - (span.latitudeDelta/2),
                               longitude: center.longitude + (span.longitudeDelta/2))
    }

    func mapRect() -> MKMapRect {
        let topLeftPoint = MKMapPoint(topLeft)
        let bottomRightPoint = MKMapPoint(bottomRight)

        return MKMapRect(origin: MKMapPoint(x: min(topLeftPoint.x, bottomRightPoint.x),
                                            y: min(topLeftPoint.y, bottomRightPoint.y)),
                         size: MKMapSize(width: abs(topLeftPoint.x-bottomRightPoint.x),
                                         height: abs(topLeftPoint.y-bottomRightPoint.y)))
    }
}
