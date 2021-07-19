//
//  NSLayoutConstraintExtensions.swift
//  FieldAgent
//
//  Created by Logan Cautrell on 1/24/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import UIKit

public extension NSLayoutConstraint {

    static func pin(view subview: UIView, inside superview: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        subview.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
        subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
        subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right).isActive = true
        subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
    }

    static func pinLeftRight(view subview: UIView, inside superview: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
        subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right).isActive = true
    }

    static func pinTop(view subview: UIView, inside superview: UIView, inset: CGFloat = 0.0) {
        subview.topAnchor.constraint(equalTo: superview.topAnchor, constant: inset).isActive = true
    }

    static func pinBottom(view subview: UIView, inside superview: UIView, inset: CGFloat = 0.0) {
        subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset).isActive = true
    }

    static func pinTopBottom(view subview: UIView, inside superview: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        subview.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
        subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
    }

    static func pinCenter(view subview: UIView, inside superview: UIView) {
        subview.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }

    static func safePinBottom(of ofView: UIView, to toView: UIView, inset: CGFloat = 0.0) {
        let constraint = ofView.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: -inset)
        constraint.priority = UILayoutPriority(999.9)
        constraint.isActive = true
    }
}
