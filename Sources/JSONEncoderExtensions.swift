//
//  JSONEncoderExtensions.swift
//  SwiftExtensions
//
//  Created by Abraham Narvaez on 7/9/20.
//  Copyright © 2020 Sentera. All rights reserved.
//

import Foundation

public extension JSONEncoder {
    static func encoderWithIsoDateEncoding() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}
