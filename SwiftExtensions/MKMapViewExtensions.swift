//
//  MKMapViewExtensions.swift
//  FieldAgent
//
//  Created by Bryan Rahn on 10/3/17.
//  Copyright © 2017 Sentera. All rights reserved.
//

import MapKit

public extension MKMapView {
    var zoomLevel: Double {
        log2(360 * (Double(frame.size.width/256) / region.span.longitudeDelta))
    }
}
