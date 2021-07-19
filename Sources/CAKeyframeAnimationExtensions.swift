//
//  CAKeyframeAnimationExtensions.swift
//  SwiftExtensions
//
//  Created by Bryan Rahn on 5/29/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import QuartzCore

public extension CAKeyframeAnimation {

    private enum TranslationType {
        case x
        case y
        case z
    }

    class func cellPeek() -> CAKeyframeAnimation {
        let result = CAKeyframeAnimation.calculateBounceValues(translationType: .x, initialMomentum: 110.0, gravity: 300.0, dampening: 0.3)
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.repeatCount = 1
        animation.duration = result.1
        animation.fillMode = .forwards
        animation.values = result.0
        animation.isRemovedOnCompletion = true // final stage is equal to starting stage
        animation.autoreverses = false

        return animation
    }

    // Converted from: https://www.cocoanetics.com/2012/06/lets-bounce/
    private static func calculateBounceValues(translationType: TranslationType,
                                              initialMomentum: CGFloat = 100.0,
                                              gravity: CGFloat = 250.0,
                                              dampening: CGFloat = 0.6) -> ([NSValue], Double) {
        var momentum = initialMomentum // momentum starts with initial value
        var positionOffset: CGFloat = 0.0 // we begin at the original position
        let slicesPerSecond: CGFloat = 60.0 // how many values per second to calculate
        let lowerMomentumCutoff: CGFloat = 5.0 // below this upward momentum animation ends

        var duration = 0.0
        var values = [NSValue]()

        repeat {
            duration += Double(1.0/slicesPerSecond)
            positionOffset += momentum/slicesPerSecond

            if positionOffset < 0 {
                positionOffset = 0
                momentum = -momentum * dampening
            }

            // gravity pulls the momentum down
            momentum -= gravity/slicesPerSecond

            switch translationType {
            case .x:
                values.append(NSValue(caTransform3D: CATransform3DMakeTranslation(-positionOffset, 0, 0)))
            case .y:
                values.append(NSValue(caTransform3D: CATransform3DMakeTranslation(0, -positionOffset, 0)))
            case .z:
                values.append(NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, -positionOffset)))
            }
        } while (!(positionOffset == 0 && momentum < lowerMomentumCutoff))

        return (values, duration)
    }
}
