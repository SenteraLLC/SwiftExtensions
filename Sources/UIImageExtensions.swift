//
//  UIImageExtensions.swift
//  FieldAgent
//
//  Created by Bryan Rahn on 10/17/18.
//  Copyright © 2018 Sentera. All rights reserved.
//

import CoreServices
import UIKit
import VideoToolbox

// MARK: - CVPixelBuffer

public extension UIImage {
    convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)

        if let cgImage = cgImage {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }

    func pixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context!)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }
}

// MARK: ImageIO

public enum ImageIOMetadataKeys: String {
    case relativeAltitudeKey = "RelativeAltitude"
    case gimbalYawDegreeKey = "GimbalYawDegree"
}

public extension UIImage {

    static func imageGPSOnlyPropertyDictionary(fileUrl url: URL) -> [String: Any]? {
        guard let data = NSData(contentsOf: url) else {
            return nil
        }

        let bytes = data.bytes.assumingMemoryBound(to: UInt8.self)

        let cfdata = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, bytes, data.count, kCFAllocatorNull)!
        let source = CGImageSourceCreateWithData(cfdata, nil)!
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as NSDictionary?,
            let gpsDictionary = properties[kCGImagePropertyGPSDictionary] as? [String: Any] else {
                print("can't get gpsDictionary")
                return nil
        }
        return gpsDictionary
    }

    static func imagePropertyDictionary(fileUrl url: URL) -> [String: Any]? {
        guard let data = NSData(contentsOf: url) else {
            return nil
        }

        let bytes = data.bytes.assumingMemoryBound(to: UInt8.self)

        var dictionary: [String: Any]?
        let cfdata = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, bytes, data.count, kCFAllocatorNull)!
        let source = CGImageSourceCreateWithData(cfdata, nil)!
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as NSDictionary?,
            let gpsDictionary = properties[kCGImagePropertyGPSDictionary] as? [String: Any],
            let tiffDictionary = properties[kCGImagePropertyTIFFDictionary] as? [String: Any] else {
                print("can't get gpsDictionary")
                return nil
        }

        dictionary = gpsDictionary
        dictionary?.merge(tiffDictionary, uniquingKeysWith: { current, _ -> Any in
            current
        })

        return dictionary
    }

    static func metadata(from properties: [String: Any]) -> NSDictionary {
        let nsDictProperties = properties as NSDictionary
        let gpsProperties: NSDictionary = [kCGImagePropertyGPSDictionary: nsDictProperties]
        let tiffProperties: NSDictionary = [kCGImagePropertyTIFFDictionary: nsDictProperties]
        let exifProperties: NSDictionary = [kCGImagePropertyExifDictionary: nsDictProperties]
        let iptcProperties: NSDictionary = [kCGImagePropertyIPTCDictionary: nsDictProperties]

        return gpsProperties + tiffProperties + exifProperties + iptcProperties
    }
    
    static func writeMetadataToPng(image: CGImage, toFileUrl url: URL, properties: [String: Any]) -> Bool {
        guard let imageDestination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypePNG, 1, nil) else {
            return false
        }

        let nsDictProperties = metadata(from: properties)
        CGImageDestinationAddImage(imageDestination, image, nsDictProperties as CFDictionary)
        CGImageDestinationFinalize(imageDestination)

        return true
    }

    static func writeMetadataToPng(fileUrl url: URL, properties: [String: Any]) -> Bool {
        guard let image = UIImage(contentsOfFile: url.path), let cgImage = image.cgImage else {
            return false
        }
        return writeMetadataToPng(image: cgImage, toFileUrl: url, properties: properties)
    }

    // swiftlint:disable force_cast
    static func metadata(fileUrl url: URL) -> [ImageIOMetadataKeys: Any] {
        var metadataDictionary = [ImageIOMetadataKeys: Any]()

        guard let data = NSData(contentsOf: url) else {
            print("cant get file data")
            return metadataDictionary
        }

        let bytes = data.bytes.assumingMemoryBound(to: UInt8.self)

        let cfdata = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, bytes, data.count, kCFAllocatorNull)!
        let source = CGImageSourceCreateWithData(cfdata, nil)!
        guard let metadata = CGImageSourceCopyMetadataAtIndex(source, 0, nil) as CGImageMetadata? else {
            print("can't get metadata")
            return metadataDictionary
        }
        guard let tags: NSArray = CGImageMetadataCopyTags(metadata) else {
            print("can't get metadata tags")
            return metadataDictionary
        }

        // Swift has a bug where it doesn't understand core foundation types. You can't use as? or as.
        // You must use as!. This code will never crash as CGImageMetadataCopyTags ALWAYS returns
        // CGImageMetadataTag. Stupid swift...

        var altitudeValue: Any?
        var yawValue: Any?
        for tag in tags {
            let metadataTag = tag as! CGImageMetadataTag
            let name = CGImageMetadataTagCopyName(metadataTag) as NSString?
            if name?.isEqual(to: ImageIOMetadataKeys.relativeAltitudeKey.rawValue) ?? false {
                altitudeValue = CGImageMetadataTagCopyValue(metadataTag)
            } else if name?.isEqual(to: ImageIOMetadataKeys.gimbalYawDegreeKey.rawValue) ?? false {
                yawValue = CGImageMetadataTagCopyValue(metadataTag)
            }
        }

        guard let altitude = altitudeValue as? NSString else {
            print("can't get altitude")
            return metadataDictionary
        }
        metadataDictionary[ImageIOMetadataKeys.relativeAltitudeKey] = altitude.doubleValue

        guard let yaw = yawValue as? NSString else {
            print("can't get yaw")
            return metadataDictionary
        }
        metadataDictionary[ImageIOMetadataKeys.gimbalYawDegreeKey] = yaw.doubleValue

        return metadataDictionary
    }
    // swiftlint:enable force_cast
}

// MARK: - Custom text drawing

public enum ImageProcessingError: Error {
    case noImage
}

public extension UIImage {
    func drawTextOverlay(text: String, font: UIFont, color: UIColor = .white) throws -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

        let textFontAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
                                                                 NSAttributedString.Key.foregroundColor: color]
        draw(in: CGRect(origin: CGPoint.zero, size: size))

        let textSize = text.size(withAttributes: textFontAttributes)
        var rect = CGRect.zero
        rect.size = textSize
        rect.origin.x = size.width / 2.0 - textSize.width / 2.0
        rect.origin.y = size.height / 2.0 - textSize.height / 2.0
        text.draw(in: rect, withAttributes: textFontAttributes)

        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            throw ImageProcessingError.noImage
        }
        return img
    }

    class func roundCircleImage(diameter: CGFloat, color: UIColor, text: String, font: UIFont) throws -> UIImage {
        let background = roundCircleImage(diameter: diameter, color: color)
        return try background.drawTextOverlay(text: text, font: font)
    }

    class func roundCircleImage(diameter: CGFloat,
                                color: UIColor,
                                renderingMode: RenderingMode = .alwaysOriginal) -> UIImage {
        let bounds = CGRect(x: 0.0, y: 0.0, width: diameter, height: diameter)
        let render = UIGraphicsImageRenderer(bounds: bounds)
        return render.image { context in
            let path = UIBezierPath(ovalIn: bounds)
            color.setFill()
            path.fill()
        }.withRenderingMode(renderingMode)
    }
}

public extension UIImage {
    func imageWithAlpha(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}

public extension UIImage {
    static func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { rendererContext in
            color.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
