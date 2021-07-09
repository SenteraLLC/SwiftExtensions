//
//  CVPixelBufferExtensions.swift
//  FieldAgent
//
//  Created by Logan Cautrell on 10/31/18.
//  Copyright © 2018 Sentera. All rights reserved.
//

import CoreVideo

public extension CVPixelBuffer {
    /// Deep copy a CVPixelBuffer:
    ///   http://stackoverflow.com/questions/38335365/pulling-data-from-a-cmsamplebuffer-in-order-to-create-a-deep-copy
    func copy() -> CVPixelBuffer {
        precondition(CFGetTypeID(self) == CVPixelBufferGetTypeID(), "copy() cannot be called on a non-CVPixelBuffer")

        var _copy: CVPixelBuffer?

        CVPixelBufferCreate(
            nil,
            CVPixelBufferGetWidth(self),
            CVPixelBufferGetHeight(self),
            CVPixelBufferGetPixelFormatType(self),
            CVBufferGetAttachments(self, .shouldPropagate),
            &_copy)

        guard let copy = _copy else { fatalError() }

        CVPixelBufferLockBaseAddress(self, .readOnly)
        CVPixelBufferLockBaseAddress(copy, [])
        defer {
            CVPixelBufferUnlockBaseAddress(copy, [])
            CVPixelBufferUnlockBaseAddress(self, .readOnly)
        }

        for plane in 0 ..< CVPixelBufferGetPlaneCount(self) {
            let dest        = CVPixelBufferGetBaseAddressOfPlane(copy, plane)
            let source      = CVPixelBufferGetBaseAddressOfPlane(self, plane)
            let height      = CVPixelBufferGetHeightOfPlane(self, plane)
            let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(self, plane)

            memcpy(dest, source, height * bytesPerRow)
        }

        return copy
    }

    // Modified from:
    // https://github.com/brianadvent/UIImage-to-CVPixelBuffer/blob/master/ImageProcessor.swift
    //  Created by Brian Advent on 09.06.17.
    //  Copyright © 2017 Brian Advent. All rights reserved.
    //
    // Need to handle kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
    //
    static func pixelBuffer(forImage image: CGImage) -> CVPixelBuffer? {
        let frameSize = CGSize(width: image.width, height: image.height)

        var buffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), kCVPixelFormatType_32BGRA, nil, &buffer)
        guard status == kCVReturnSuccess,
            let pixelBuffer = buffer else {
                return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)

        context?.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }
}
