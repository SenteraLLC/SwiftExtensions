//
//  MKMultiPointExtensions.swift
//  SwiftExtensions
//
//  Created by Logan Cautrell on 8/26/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import MapKit

public extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
