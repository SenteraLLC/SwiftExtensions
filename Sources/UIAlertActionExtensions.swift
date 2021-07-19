//
//  UIAlertActionExtensions.swift
//  FieldAgent
//
//  Created by Logan Cautrell on 4/17/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import UIKit

public extension UIAlertAction {
    static func defaultAction(title: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        UIAlertAction(title: title, style: .default, handler: handler)
    }
    static func okAction(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        UIAlertAction.defaultAction(title: "OK", handler: handler)
    }
    static func dismissAction(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        UIAlertAction(title: "Dismiss", style: .cancel, handler: handler)
    }
    static func cancelAction(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        UIAlertAction(title: "Cancel", style: .cancel, handler: handler)
    }
}
