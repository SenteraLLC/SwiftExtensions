//
//  UITableViewHeaderFooterViewExtensions.swift
//  SwiftExtensions
//
//  Created by Bryan Rahn on 8/3/20.
//  Copyright © 2020 Sentera. All rights reserved.
//

import UIKit

public extension UITableViewHeaderFooterView {
    static var identifier: String {
        String(describing: self)
    }
}
