//
//  CLLocationCoordinate2DExtensions.swift
//  FieldAgent
//
//  Created by Logan Cautrell on 4/9/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import CoreLocation

extension CLLocationDegrees {

    // latitude in degrees is -90 and +90
    // longitude in degrees is -180 and +180
    static let minLatitude = CLLocationDegrees(-90.0)
    static let maxLatitude = CLLocationDegrees(90.0)
    static let minLongitude = CLLocationDegrees(-180.0)
    static let maxLongitude = CLLocationDegrees(180.0)
}

public extension CLLocationCoordinate2D {
    // http://www.remotebits.com/index.php/2017/12/17/how-to-calculate-compass-heading-from-gps-points/
     func heading(to: CLLocationCoordinate2D) -> Double {
         let heading = (450.0 - angle(to: to)).truncatingRemainder(dividingBy: 360.0)
         if heading == 360.0 {
             return 0.0
         }
         return heading
     }

    func angle(to: CLLocationCoordinate2D) -> Double {
         let y1 = latitude
         let x1 = longitude
         let y2 = to.latitude
         let x2 = to.longitude
         return atan2(y2 - y1, x2 - x1).radToDeg()
     }

    func isValid() -> Bool {
        if self == kCLLocationCoordinate2DInvalid {
            return false
        }
        if latitude > CLLocationDegrees.maxLatitude || latitude < CLLocationDegrees.minLatitude {
            return false
        }
        if longitude > CLLocationDegrees.maxLongitude || longitude < CLLocationDegrees.minLongitude {
            return false
        }
        return true
    }

    func isNull() -> Bool {
        latitude == 0.0 && longitude == 0.0
    }

    static func randomCoordinate() -> CLLocationCoordinate2D {
        let lat = CLLocationDegrees.random(in: CLLocationDegrees.minLatitude...CLLocationDegrees.maxLatitude)
        let lon = CLLocationDegrees.random(in: CLLocationDegrees.minLongitude...CLLocationDegrees.maxLongitude)
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude.hashValue)
        hasher.combine(longitude.hashValue)
    }
}

// Swift doesn't allow structs to be used as a generic "where" constraint...
public protocol LocationCoordinate2D {
    var latitude: CLLocationDegrees { get }
    var longitude: CLLocationDegrees { get }
}
extension CLLocationCoordinate2D: LocationCoordinate2D { }

public extension Array where Iterator.Element: LocationCoordinate2D {
    func isAlmostEqual(to other: [LocationCoordinate2D]) -> Bool {
        guard count == other.count else {
            return false
        }
        var iterator = makeIterator()
        var otherIterator = other.makeIterator()
        while let coordinate = iterator.next(),
              let otherCoordinate = otherIterator.next() {
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let otherLocation = CLLocation(latitude: otherCoordinate.latitude, longitude: otherCoordinate.longitude)
                if location.distance(from: otherLocation) > 1.0 {
                return false
            }
        }
        return true
    }
}
