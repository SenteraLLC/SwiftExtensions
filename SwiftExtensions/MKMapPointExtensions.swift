//
//  MKMapPointExtensions.swift
//  SwiftExtensions
//
//  Created by Logan Cautrell on 6/17/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import MapKit

public extension MKMapPoint {
    func angle(to: MKMapPoint) -> Double {
         let y1 = y
         let x1 = x
         let y2 = to.y
         let x2 = to.x
         return atan2(y2 - y1, x2 - x1).radToDeg()
     }

     // http://www.remotebits.com/index.php/2017/12/17/how-to-calculate-compass-heading-from-gps-points/
     func heading(to: MKMapPoint) -> Double {
         let heading = (450.0 - angle(to: to)).truncatingRemainder(dividingBy: 360.0)
         if heading == 360.0 {
             return 0.0
         }
         return heading
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
