//
//  ExtensionUIImage.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 21.02.2022.
//

import SwiftUI

extension UIImage {
    var croppedToDeviceScreen: UIImage? {
        let screenAspectRatio = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        let width = screenAspectRatio * size.height
        let rect = CGRect(
            x: (size.width - width) / 2,
            y: 0,
            width: width,
            height: size.height
        )
        guard let cgImage = cgImage,
              let image = cgImage.cropping(to: rect)
        else { return nil }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }

    var topThird: UIImage? {
        let rect = CGRect(
            origin: .zero,
            size: .init(width: size.width, height: (size.height - size.width) / 2)
        )
        guard let cgImage = cgImage,
              let image = cgImage.cropping(to: rect)
        else { return nil }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }

    var centerThird: UIImage? {
        let rect = CGRect(
            origin: .init(x: 0, y: (size.height - size.width) / 2),
            size: .init(width: size.width, height: size.width)
        )
        guard let cgImage = cgImage,
              let image = cgImage.cropping(to: rect)
        else { return nil }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }

    var bottomThird: UIImage? {
        let rect = CGRect(
            origin: .init(x: 0,  y: (size.height - size.width) / 2 + size.width),
            size: .init(width: size.width, height: (size.height - size.width) / 2)
        )
        guard let cgImage = cgImage,
              let image = cgImage.cropping(to: rect)
        else { return nil }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }
}
