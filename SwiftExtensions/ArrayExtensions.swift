//
//  ArrayExtensions.swift
//  FieldAgent
//
//  Copyright © 2021 Sentera. All rights reserved.
//

import Foundation

public extension Array {
    func enumeratedPairs() -> [(Index, Element, Index, Element)] {
        enumerated().map { index, element in
            let index2 = (index - 1) < 0 ? count - 1 : index - 1
            let element2 = self[index2]
            return (index2, element2, index, self[index])
        }
    }
}

public extension Array where Element: Hashable {
    mutating func removeAdjacentDuplicates() {
        var elements = [Element]()

        forEach { e in
            if let last = elements.last {
                if last != e {
                    elements.append(e)
                }
            } else {
                // No items in list, append
                elements.append(e)
            }
        }
        self = elements
    }
}
