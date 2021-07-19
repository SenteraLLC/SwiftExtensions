//
//  CGPointExtensions.swift
//  FieldAgent
//
//  Created by Logan Cautrell on 12/20/18.
//  Copyright © 2018 Sentera. All rights reserved.
//

import CoreGraphics

public extension CGPoint {
    func offset(x: CGFloat, y: CGFloat) -> CGPoint {
        CGPoint(x: self.x + x, y: self.y + y)
    }
}
