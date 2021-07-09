//
//  UIImageExtensionsTests.swift
//  FieldAgentTests
//
//  Created by Abraham Narvaez on 2/16/20.
//  Copyright © 2020 Sentera. All rights reserved.
//

import CoreServices
import Foundation
import SwiftExtensions
import XCTest

class UIImageExtensionsTests: XCTestCase {

    func testImagePropertyDictionary() {
        let tempDirectory = NSTemporaryDirectory()
        let url = URL(fileURLWithPath: tempDirectory, isDirectory: true).appendingPathComponent("blank.png")

        let properties = UIImage.imagePropertyDictionary(fileUrl: url)
        print(String(describing: properties))
    }

    func testWriteImageProperties() {
        let tempDirectory = NSTemporaryDirectory()
        let url = URL(fileURLWithPath: tempDirectory, isDirectory: true).appendingPathComponent("blank.png")
        let path = url.path
        var blankImage = makeImageHelper(color: .white)
        let imageData = blankImage.pngData()

        do {
            try imageData?.write(to: url)
        } catch {
            print("Error: \(error)")
        }

        blankImage = UIImage(contentsOfFile: path)!

        let properties = [
            kCGImagePropertyGPSLatitude: 0.0,
            kCGImagePropertyGPSLongitude: 0.0,
            kCGImagePropertyGPSAltitude: 0.0,
            kCGImagePropertyGPSAltitudeRef: 0.0,
            kCGImagePropertyTIFFMake: "moo",
            kCGImagePropertyTIFFModel: "quack",
            kCGImagePropertyExifLensSerialNumber: "woof",
            kCGImagePropertyExifCameraOwnerName: "chirp",
            kCGImagePropertyIPTCKeywords: "ugh",
            ImageIOMetadataKeys.relativeAltitudeKey.rawValue as CFString: 1090.0
        ] as [String: Any]

        let success = UIImage.writeMetadataToPng(fileUrl: url, properties: properties)

        // for checking in the console
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
            print(CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)!)
        }

        XCTAssertEqual(success, true)
    }

    func testMetadata() {
        let tempDirectory = NSTemporaryDirectory()
        let url = URL(fileURLWithPath: tempDirectory, isDirectory: true).appendingPathComponent("blank.png")
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
            print(CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)!)
        }

        let properties = UIImage.metadata(fileUrl: url)
        print(String(describing: properties))
    }

    func makeImageHelper(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return UIImage() }
        return UIImage(cgImage: cgImage)
    }
}
