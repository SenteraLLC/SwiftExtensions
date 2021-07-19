//
//  UIAlertControllerExtensions.swift
//  SwiftExtensions
//
//  Created by Bryan Rahn on 2/7/20.
//  Copyright © 2020 Sentera. All rights reserved.
//

import MapKit
import UIKit

public extension UIAlertController {
    static func presentDrivingDirectionsActionSheet(to mapItem: MKMapItem,
                                                    from viewController: UIViewController,
                                                    sourceView: UIView,
                                                    sourceRect: CGRect,
                                                    cancelCompletion: (() -> Void)? = nil) {

        var actions = [UIAlertAction]()
        let openMapsAction = UIAlertAction(title: "Open in Apple Maps", style: .default) { alertAction in
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
        actions.append(openMapsAction)

        // Add Google Maps option if installed
        if let googleBaseURL = URL(string: "comgooglemaps://"),
            UIApplication.shared.canOpenURL(googleBaseURL),
            let googleDirectionsURL = URL(string: "comgooglemaps://?saddr=&daddr=\(mapItem.placemark.coordinate.latitude),\(mapItem.placemark.coordinate.longitude)&directionsmode=driving") {
            let openGoogleMapsAction = UIAlertAction(title: "Open in Google Maps", style: .default) { alertAction in
                UIApplication.shared.open(googleDirectionsURL, options: [:], completionHandler: nil)
            }
            actions.append(openGoogleMapsAction)
        }

        UIAlertController.presentActionSheetAlertController(title: "Map Options", message: nil, actions: actions, from: viewController, sourceView: sourceView, sourceRect: sourceRect)
    }

    static func presentActionSheetAlertController(title: String?,
                                                  message: String?,
                                                  actions: [UIAlertAction],
                                                  from viewController: UIViewController,
                                                  sourceView: UIView,
                                                  sourceRect: CGRect,
                                                  cancelCompletion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .actionSheet)

        actions.forEach {
            alertController.addAction($0)
        }

        alertController.addAction(UIAlertAction.cancelAction(handler: { action in
            cancelCompletion?()
        }))

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sourceView
            popoverController.sourceRect = sourceRect
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
}
