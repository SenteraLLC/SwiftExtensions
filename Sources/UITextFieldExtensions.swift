//
//  UITextFieldExtensions.swift
//  FieldAgent
//
//  Created by Bryan Rahn on 8/1/17.
//  Copyright © 2017 Sentera. All rights reserved.
//

import UIKit

public extension UITextField {
    var count: Int {
        self.text?.count ?? 0
    }
}
