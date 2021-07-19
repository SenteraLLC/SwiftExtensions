//
//  NotificationCenterAdditionsTests.swift
//  SwiftExtensionsTests
//
//  Created by Abraham Narvaez on 7/15/20.
//  Copyright © 2020 Sentera. All rights reserved.
//

import Foundation
import XCTest

class NotificationCenterAdditionsTests: XCTestCase {

    func testNotificationToken() {
        var observables = [NSObjectProtocol]()
        var executed = false

        var token = NotificationCenter.observe(for: .shouldObserve, queue: nil) { _ in
            executed = true
        }
        observables.append(token)
        token = NotificationCenter.observe(for: .shantObserve, queue: nil) { _ in
            XCTFail("XCTFail: observer not removed.")
        }
        observables.append(token)

        let expect = expectation(forNotification: .shouldObserve, object: self) { _ in
            if executed {
                return true
            }
            return false
        }

        NotificationCenter.post(name: .shouldObserve, object: self)
        wait(for: [expect], timeout: 1)

        observables = []
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            NotificationCenter.post(name: .shantObserve, object: self)
        }
    }
}

extension Notification.Name {
    static let shouldObserve = Notification.Name("shouldObserve")
    static let shantObserve = Notification.Name("shantObserve")
}
