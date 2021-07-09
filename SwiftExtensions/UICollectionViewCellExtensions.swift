//
//  UICollectionViewCellExtensions.swift
//  FieldAgent
//
//  Created by Bryan Rahn on 1/16/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import UIKit

public extension UICollectionViewCell {
    static var identifier: String {
        String(describing: self)
    }
}
