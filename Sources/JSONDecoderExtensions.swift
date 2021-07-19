//
//  JSONDecoderExtensions.swift
//  SwiftExtensions
//
//  Created by Abraham Narvaez on 7/9/20.
//  Copyright © 2020 Sentera. All rights reserved.
//

import Foundation

public extension JSONDecoder {
    static func decoderWithIsoDateDecoding() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    /// Decodes an object using a keypath. https://gist.github.com/sgr-ksmt/d3b79ed1504768f2058c5ea06dc93698
    /// - Parameters:
    ///   - type: `T`
    ///   - data: The `Data` to be processed
    ///   - keyPath: The keypath of the leaf node
    /// - Throws: `DecodingError`
    /// - Returns: `T`
    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
        let toplevel = try JSONSerialization.jsonObject(with: data)
        if let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
            return try decode(type, from: nestedJsonData)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested json not found for key path \"\(keyPath)\""))
        }
    }
}
