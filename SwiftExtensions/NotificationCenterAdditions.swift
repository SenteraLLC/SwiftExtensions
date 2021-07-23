//
//  NotificationCenterAdditions.swift
//  FieldAgent
//
//  Created by Logan Cautrell on 10/12/18.
//  Copyright © 2018 Sentera. All rights reserved.
//

import Foundation

public final class NotificationToken: NSObject {

    private let notificationCenter: NotificationCenter
    private let token: NSObjectProtocol

    init(notificationCenter: NotificationCenter = .default, token: NSObjectProtocol) {
        self.notificationCenter = notificationCenter
        self.token = token
    }

    deinit {
        notificationCenter.removeObserver(token)
    }
}

public extension NotificationCenter {

    static func observe(for name: NSNotification.Name?, queue: OperationQueue?, block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        let token = NotificationCenter.default.addObserver(forName: name, object: nil, queue: queue, using: block)
        return NotificationToken(token: token)
    }

    static func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: aName, object: nil)
    }

    static func removeObserver(_ observer: Any, name aName: NSNotification.Name?) {
        NotificationCenter.default.removeObserver(observer, name: aName, object: nil)
    }

    static func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }

    static func post(name aName: NSNotification.Name) {
        NotificationCenter.default.post(name: aName, object: nil)
    }

    static func postOnMainQueue(name aName: NSNotification.Name) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: aName, object: nil)
        }
    }

    static func post(name aName: NSNotification.Name, object anObject: Any?, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: aName, object: anObject, userInfo: userInfo)
    }

    static func postOnMainQueue(name aName: NSNotification.Name, object anObject: Any?, userInfo: [AnyHashable: Any]? = nil) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: aName, object: anObject, userInfo: userInfo)
        }
    }

    static func publisher(for name: Notification.Name) -> NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: name)
    }
}

