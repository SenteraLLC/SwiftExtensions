//
//  UIViewExtensions.swift
//  OnTop
//
//  Created by Bryan Rahn on 6/7/17.
//  Copyright © 2017 Sentera. All rights reserved.
//

import UIKit

public extension UIVisualEffectView {

    convenience init(cornerRadius: CGFloat, style: UIBlurEffect.Style = .systemThickMaterial) {
        self.init(effect: UIBlurEffect(style: style))
        translatesAutoresizingMaskIntoConstraints = false
        if cornerRadius > 0.0 {
            clipsToBounds = true
            layer.cornerRadius = cornerRadius
        }
    }
}

public extension UIView {
    convenience init(autoLayout: Bool = true) {
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = !autoLayout
    }

    static func buildSummaryIconTitleValueRow(leftView: UIView, rightView: UIView, horizontalMargin: CGFloat) -> UIView {
        let view = UIView(autoLayout: true)
        view.addSubview(leftView)
        view.addSubview(rightView)

        leftView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        leftView.trailingAnchor.constraint(lessThanOrEqualTo: view.centerXAnchor, constant: -horizontalMargin).isActive = true
        NSLayoutConstraint.pinTopBottom(view: leftView, inside: view)

        rightView.leadingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rightView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor).isActive = true
        NSLayoutConstraint.pinTopBottom(view: rightView, inside: view)

        return view
    }
    
    func startRotating(duration: Double = 1) {
        let kAnimationKey = "spin"
        
        if layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation.z")
            animate.duration = duration
            animate.repeatCount = .infinity
            animate.fromValue = 0.0
            animate.byValue = Double.pi
            animate.toValue = .pi * 2.0
            animate.isRemovedOnCompletion = false
            layer.add(animate, forKey: kAnimationKey)
        }
    }
    
    func stopRotating(animated: Bool) {
        let kAnimationKey = "spin"
        
        if layer.animation(forKey: kAnimationKey) != nil {
            
            guard var currentValue = layer.presentation()?.value(forKeyPath: "transform.rotation.z") as? Double, animated else {
                layer.removeAnimation(forKey: kAnimationKey)
                return
            }
            
            if currentValue < 0 {
                currentValue += 2 * .pi
            }
            
            let animate = CABasicAnimation(keyPath: "transform.rotation.z")
            let duration = (1.0 - (currentValue / 2 * .pi))
            animate.duration = duration
            animate.fromValue = currentValue
            animate.toValue = .pi * 2.0
            layer.removeAnimation(forKey: kAnimationKey)
            layer.add(animate, forKey: kAnimationKey)
        }
    }

    func createTopInnerShadow(from: UIColor, to: UIColor, radius: CGFloat) -> CAGradientLayer {
        let gradientlayer = CAGradientLayer()
        gradientlayer.colors = [from.cgColor, to.cgColor]
        gradientlayer.shadowRadius = radius
        gradientlayer.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: gradientlayer.shadowRadius)
        return gradientlayer
    }

    func createBottomOuterShadow(from: UIColor, to: UIColor, radius: CGFloat) -> CAGradientLayer {
        let gradientlayer = CAGradientLayer()
        gradientlayer.colors = [from.cgColor, to.cgColor]
        gradientlayer.shadowRadius = radius
        gradientlayer.frame = CGRect(x: 0.0, y: bounds.maxY, width: bounds.width, height: gradientlayer.shadowRadius)
        return gradientlayer
    }

    func setBreakable() {
        setContentHuggingPriority(.highestBreakable, for: .vertical)
        setContentHuggingPriority(.highestBreakable, for: .horizontal)
        setContentCompressionResistancePriority(.highestBreakable, for: .vertical)
        setContentCompressionResistancePriority(.highestBreakable, for: .horizontal)
    }
}

public extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { allSubviews, subview -> [UIView] in
            removeArrangedSubview(subview)
            return allSubviews + [subview]
        }

        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))

        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
