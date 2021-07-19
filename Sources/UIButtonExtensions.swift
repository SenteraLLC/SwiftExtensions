//
//  UIButtonExtensions.swift
//  SwiftExtensions
//
//  Created by Bryan Rahn on 11/14/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import UIKit

public extension UIButton {
    // swiftlint:disable override_in_extension
    // Workaround: UIButton intrinsicContentSize does not account for titleEdgeInsets
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + titleEdgeInsets.left + titleEdgeInsets.right,
                      height: size.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
    }
    // swiftlint:enable override_in_extension
}
