//
//  MKMapRectExtensions.swift
//  FieldAgent
//
//  Created by Logan Cautrell on 10/11/18.
//  Copyright © 2018 Sentera. All rights reserved.
//

import MapKit

public extension MKMapRect {

    static func mapRect(for annotations: [MKAnnotation], insetPercentage: Double = 0.1) -> MKMapRect {
        mapRect(for: annotations.map {
            $0.coordinate
        })
    }

    static func mapRect(topLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D, insetPercentage: Double = 0.0) -> MKMapRect {
        let size = MKMapSize(width: 0, height: 0)
        let bottomRightRect = MKMapRect(origin: MKMapPoint(bottomRight), size: size)
        var rect = MKMapRect(origin: MKMapPoint(topLeft), size: size).union(bottomRightRect)
        rect = rect.insetBy(dx: -rect.size.width * insetPercentage, dy: -rect.size.height * insetPercentage)
        return rect
    }

    static func mapRect(for coordinates: [CLLocationCoordinate2D], insetPercentage: Double = 0.1, minRegionSpan: CLLocationDegrees = 0.1) -> MKMapRect {
        guard let coordinate = coordinates.first else {
            return MKMapRect.null
        }

        let size = MKMapSize(width: 0, height: 0)
        var rect = MKMapRect(origin: MKMapPoint(coordinate), size: size)

        coordinates.forEach { coordinate in
            let point = MKMapPoint(coordinate)
            let newRect = MKMapRect(origin: point, size: size)
            rect = rect.union(newRect)
        }

        rect = rect.insetBy(dx: -rect.size.width * insetPercentage, dy: -rect.size.height * insetPercentage)

        var region = MKCoordinateRegion(rect)
        if region.span.latitudeDelta < minRegionSpan {
            region = MKCoordinateRegion(center: region.center, span: MKCoordinateSpan(latitudeDelta: minRegionSpan, longitudeDelta: region.span.longitudeDelta))
        }
        if region.span.longitudeDelta < minRegionSpan {
            region = MKCoordinateRegion(center: region.center, span: MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta, longitudeDelta: minRegionSpan))
        }

        return region.mapRect()
    }

    func topLeftBottomRight() -> [CLLocationCoordinate2D] {
        let coordinateRegion = MKCoordinateRegion(self)
        let topLeftCoordinate =
            CLLocationCoordinate2DMake(coordinateRegion.center.latitude
                                        + (coordinateRegion.span.latitudeDelta/2.0),
                                       coordinateRegion.center.longitude
                                        - (coordinateRegion.span.longitudeDelta/2.0))
        let bottomRightCoordinate =
            CLLocationCoordinate2DMake(coordinateRegion.center.latitude
                                        - (coordinateRegion.span.latitudeDelta/2.0),
                                       coordinateRegion.center.longitude
                                        + (coordinateRegion.span.longitudeDelta/2.0))
        return [topLeftCoordinate, bottomRightCoordinate]
    }
}

extension MKMapRect: Equatable {

    public static func == (lhs: MKMapRect, rhs: MKMapRect) -> Bool {
        lhs.height == rhs.height &&
            lhs.width == rhs.width &&
            lhs.origin.x == rhs.origin.x &&
            lhs.origin.y == rhs.origin.y
    }
}
