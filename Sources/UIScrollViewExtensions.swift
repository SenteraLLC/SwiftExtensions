//
//  UIScrollViewExtensions.swift
//  FieldAgent
//
//  Created by Logan Cautrell on 5/6/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import UIKit

public extension UIScrollView {

    func scrollToBottom(animated: Bool = true) {
        setContentOffset(CGPoint(x: 0, y: contentSize.height - bounds.height), animated: animated)
    }
}
