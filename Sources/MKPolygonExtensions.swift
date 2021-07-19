//
//  MKPolygonExtensions.swift
//  SwiftExtensions
//
//  Created by Logan Cautrell on 6/17/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import MapKit

public extension MKPolygon {
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let polygonRenderer = MKPolygonRenderer(polygon: self)
        let mapPoint = MKMapPoint(coordinate)
        let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)

        return polygonRenderer.path.contains(polygonViewPoint)
    }
}
