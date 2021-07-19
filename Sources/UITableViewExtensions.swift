//
//  UITableViewExtensions.swift
//  FieldAgent
//
//  Created by Bryan Rahn on 8/23/17.
//  Copyright © 2017 Sentera. All rights reserved.
//

import UIKit

public extension UITableView {
    /// https://gist.github.com/mttcrsp/53a6fec3a5a16e020aa97926428057c9
    /// There's a known issue with the `contentOffset` being incorrect
    /// when programatically calling `refreshControl.beginRefreshing()`
    ///
    /// Note: there appears to be an issue with the `refreshControl.attributedTitle`
    /// not being displayed properly even with this hack.
    func beginRefreshing() {
        guard let refreshControl = refreshControl, !refreshControl.isRefreshing else {
            return
        }

        refreshControl.beginRefreshing()

        let contentOffset = CGPoint(x: 0, y: -refreshControl.frame.height)
        setContentOffset(contentOffset, animated: true)
    }

    func endRefreshing() {
        refreshControl?.endRefreshing()
    }

    func layoutTableHeaderView() {
        guard let view = tableHeaderView else {
            return
        }
        tableHeaderView = autolayoutTableHeaderFooterView(view: view)
    }

    func layoutTableFooterView() {
        guard let view = tableFooterView else {
            return
        }
        tableFooterView = autolayoutTableHeaderFooterView(view: view)
    }

    private func autolayoutTableHeaderFooterView(view: UIView) -> UIView {
        view.translatesAutoresizingMaskIntoConstraints = false

        let headerWidth = bounds.size.width
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[view(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["view": view])

        view.addConstraints(temporaryWidthConstraints)

        view.setNeedsLayout()
        view.layoutIfNeeded()

        let headerSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = headerSize.height
        var frame = view.frame

        frame.size.height = height
        view.frame = frame

        view.removeConstraints(temporaryWidthConstraints)
        view.translatesAutoresizingMaskIntoConstraints = true
        
        return view
    }
}
