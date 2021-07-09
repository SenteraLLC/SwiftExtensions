//
//  MKAnnotationViewExtensions.swift
//  SwiftExtensions
//
//  Created by Bryan Rahn on 12/3/20.
//  Copyright © 2020 Sentera. All rights reserved.
//

import MapKit

public extension MKAnnotationView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
