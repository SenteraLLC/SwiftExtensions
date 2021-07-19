//
//  CIImageExtensions.swift
//  FieldAgent
//
//  Created by Logan Cautrell on 12/10/18.
//  Copyright © 2018 Sentera. All rights reserved.
//

import CoreImage

public extension CIImage {
    func cgImage() -> CGImage? {
        CIContext.shared.createCGImage(self, from: extent)
    }
}
