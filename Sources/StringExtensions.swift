//
//  StringExtensions.swift
//  FieldAgent
//
//  Created by Logan Cautrell on 10/15/18.
//  Copyright © 2018 Sentera. All rights reserved.
//

import CommonCrypto
import Foundation

public extension String {
    func utf8Data() -> Data? {
        data(using: .utf8)
    }

    func lastPathComponent() -> String? {
        components(separatedBy: "/").last
    }

    func lastPathComponentOrEmpty() -> String {
        lastPathComponent() ?? ""
    }

    func isNumber() -> Bool {
        !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    func trimmingWhitespace() -> String {
        self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func stripAllWhitespace() -> String {
        self.filter {
            !$0.isNewline && !$0.isWhitespace
        }
    }

    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in 
            letters.randomElement() ?? "a"
        })
    }

    func acronym() -> String {
        components(separatedBy: " ").filter {
            !$0.isEmpty
        }.reduce("") {
            $0 + $1.dropLast($1.count-1)
        }.uppercased()
    }

    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }

    // Apple's current Swift String implementation is completely broken..
    // WTF APPLE!
    func stringByAddingPercentEncoding() -> String? {
        let unreserved = "#%;<>?[\\]^`{|}"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }

    var sha256: String {
        let data = Data(utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))

        data.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress, CC_LONG(buffer.count), &hash)
        }

        return hash.map { String(format: "%02X", $0) }.joined()
    }

    var sha256URLEncoded: String? {
        sha256.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
