//
//  UIViewControllerExtensions.swift
//  FieldAgent
//
//  Created by Bryan Rahn on 9/19/17.
//  Copyright © 2017 Sentera. All rights reserved.
//

import AVKit
import SafariServices
import UIKit

public extension UIViewController {
    func presentAlertViewController(title: String?, message: String?, actions: [UIAlertAction], preferredStyle: UIAlertController.Style = .alert, popoverSourceView: UIView? = nil, popoverSourceRect: CGRect? = nil, completion: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { action in
            alertVC.addAction(action)
        }

        if preferredStyle == .actionSheet,
            let popoverSourceRect = popoverSourceRect,
            let popover = alertVC.popoverPresentationController {
            popover.sourceRect = popoverSourceRect
            popover.sourceView = popoverSourceView
        }

        present(alertVC, animated: true, completion: completion)
    }

    func presentSupportPageViewController() {
        showSafariViewController(urlString: "https://support.sentera.com/portal/home")
    }

    func presentVideo(avAsset: AVAsset) {
        let item = AVPlayerItem(asset: avAsset)
        let player = AVPlayer(playerItem: item)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }

    func showSafariViewController(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}
