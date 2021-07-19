//
//  OperationQueueExtensions.swift
//  SwiftExtensions
//
//  Created by Logan Cautrell on 7/9/19.
//  Copyright © 2019 Sentera. All rights reserved.
//

import Foundation

public extension OperationQueue {
    static let senteraUtilityQueue = DispatchQueue(label: "senteraUtilityQueue", qos: .utility)
    static func serialQueue(with name: String, qos: DispatchQoS.QoSClass = .default) -> OperationQueue {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .default
        switch qos {
        case .utility:
            queue.underlyingQueue = senteraUtilityQueue
        default:
            queue.underlyingQueue = DispatchQueue.global(qos: qos)
        }
        queue.name = "\(name)_OperationQueue"
        return queue
    }
}
