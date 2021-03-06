//
//  UIImageExtensions.swift
//  FieldAgent
//
//  Copyright © 2021 Sentera. All rights reserved.
//

import CoreLocation
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
    case bandNameKey = "BandName"
    case makeKey = "Make"
    case focalLengthKey = "FocalLength"
}

public extension UIImage {

    // MARK: EXIF Helpers

    static func makeName(forImageAt url: URL) -> String? {
        imagePropertyDictionary(fileUrl: url)?[ImageIOMetadataKeys.makeKey.rawValue] as? String
    }

    static func focalLength(forImageAt url: URL) -> Double? {
        imagePropertyDictionary(fileUrl: url)?[ImageIOMetadataKeys.focalLengthKey.rawValue] as? Double
    }

    //swiftlint:disable force_cast
    static func bandName(forImageAt url: URL) -> String? {
        guard let tags = imageMetadataTags(fileUrl: url) else {
            return nil
        }

        var bandNameTagArray: Any?
        for tag in tags {
            // Swift has a bug where it doesn't understand core foundation types. You can't use as? or as.
            // You must use as!. This code will never crash as CGImageMetadataCopyTags ALWAYS returns
            // CGImageMetadataTag. Stupid swift...
            let metadataTag = tag as! CGImageMetadataTag
            let name = CGImageMetadataTagCopyName(metadataTag) as NSString?
            if name?.isEqual(to: ImageIOMetadataKeys.bandNameKey.rawValue) ?? false {
                bandNameTagArray = CGImageMetadataTagCopyValue(metadataTag)
            }
        }

        if let tagArray = bandNameTagArray as? [CGImageMetadataTag] {
            var bandName = tagArray.reduce("") { result, tag -> String in
                let value = CGImageMetadataTagCopyValue(tag) as? String ?? "unknown"
                return result.appending("\(value), ")
            }
            if bandName.count > 2 {
                bandName.removeLast(2)
                return bandName
            }
        }
        return nil
    }
    //swiftlint:enable force_cast

    static func locationCoordinate(for url: URL) -> CLLocationCoordinate2D? {
        guard let propertyDictionary = UIImage.imageGPSOnlyPropertyDictionary(fileUrl: url) else {
            print("can't get imagePropertyGPSDictionary from url \(url)")
            return nil
        }
        guard let lat = propertyDictionary[kCGImagePropertyGPSLatitude as String] as? Double,
            let lon = propertyDictionary[kCGImagePropertyGPSLongitude as String] as? Double,
            let northSouth = propertyDictionary[kCGImagePropertyGPSLatitudeRef as String] as? String,
            let eastWest = propertyDictionary[kCGImagePropertyGPSLongitudeRef as String] as? String else {
            print("unable to get fields")
            return nil
        }
        let latitude = northSouth == "S" ? -lat : lat
        let longitude = eastWest == "W" ? -lon : lon
        let coord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        guard coord.isValid() else {
            return nil
        }
        return coord
    }

    static func imageGPSOnlyPropertyDictionary(fileUrl url: URL) -> [String: Any]? {
        let options = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithURL(url as CFURL, options) else {
            return nil
        }
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, options) as NSDictionary?,
            let gpsDictionary = properties[kCGImagePropertyGPSDictionary] as? [String: Any] else {
                print("can't get gpsDictionary")
                return nil
        }
        return gpsDictionary
    }

    static func imagePropertyDictionary(fileUrl url: URL) -> [String: Any]? {
        let options = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithURL(url as CFURL, options) else {
            return nil
        }
        var dictionary: [String: Any]?
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, options) as NSDictionary?,
              let gpsDictionary = properties[kCGImagePropertyGPSDictionary] as? [String: Any],
              let tiffDictionary = properties[kCGImagePropertyTIFFDictionary] as? [String: Any] else {
                  print("can't get gpsDictionary")
                  return nil
              }

        let exifDictionary = (properties[kCGImagePropertyExifDictionary] as? [String: Any]) ?? [String: Any]()
        dictionary = gpsDictionary
        dictionary?.merge(tiffDictionary, uniquingKeysWith: { current, _ -> Any in
            current
        })
        dictionary?.merge(exifDictionary, uniquingKeysWith: { current, _ -> Any in
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
        let options = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithURL(url as CFURL, options) else {
            return [ImageIOMetadataKeys: Any]()
        }
        var metadataDictionary = [ImageIOMetadataKeys: Any]()
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

    private static func imageMetadataTags(fileUrl url: URL) -> NSArray? {
        let options = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithURL(url as CFURL, options) else {
            return nil
        }
        guard let metadata = CGImageSourceCopyMetadataAtIndex(source, 0, nil) as CGImageMetadata? else {
            print("can't get metadata")
            return nil
        }
        guard let tags: NSArray = CGImageMetadataCopyTags(metadata) else {
            print("can't get metadata tags")
            return nil
        }
        return tags
    }
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

public extension UIImage {
    func resize(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { (context) in
            self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        }
        return image
    }
}
