//
//  UIBezierPathExtensions.swift
//  SwiftExtensions
//
//  Created by Bryan Rahn on 9/24/20.
//  Copyright © 2020 Sentera. All rights reserved.
//
//  Usurped this code from: https://stackoverflow.com/a/55690893/418497

import UIKit

public extension UIBezierPath {
    /// Slightly modified from its original form to exclude adding a line
    /// path when index == 1 that incorrectly added control points to self
    /// where they were not needed.
    convenience init?(quadCurve points: [CGPoint]) {
        guard points.count > 1 else { return nil }
        self.init()

        if points.count > 1 {
            var prevPoint: CGPoint?
            for (index, point) in points.enumerated() {
                if index == 0 {
                    move(to: point)
                } else {
                    if prevPoint != nil {
                        let midPoint = midPointForPoints(from: prevPoint!, to: point)
                        addQuadCurve(to: midPoint, controlPoint: controlPointForPoints(from: midPoint, to: prevPoint!))
                        addQuadCurve(to: point, controlPoint: controlPointForPoints(from: midPoint, to: point))
                    }
                }
                prevPoint = point
            }
        }
    }

    func midPointForPoints(from p1: CGPoint, to p2: CGPoint) -> CGPoint {
        CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }

    func controlPointForPoints(from p1: CGPoint, to p2: CGPoint) -> CGPoint {
        var controlPoint = midPointForPoints(from: p1, to: p2)
        let  diffY = abs(p2.y - controlPoint.y)
        if p1.y < p2.y {
            controlPoint.y += diffY
        } else if p1.y > p2.y {
            controlPoint.y -= diffY
        }
        return controlPoint
    }
}
