//
//  CGRectExtensions.swift
//  SwiftExtensions
//
//  Created by Logan Cautrell on 10/1/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import CoreGraphics

public extension CGRect {
    func distanceFromCenter(to point: CGPoint) -> CGFloat {
        let xDist = midX - point.x
        let yDist = midY - point.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
}
