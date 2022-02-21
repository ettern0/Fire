//
//  Extensions.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 10.02.2022.
//

import SwiftUI

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    public convenience init(rgb: UInt32, alpha: CGFloat = 1) {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let blue = CGFloat(rgb & 0x0000FF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    var color: Color {
        .init(self)
    }
}

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

extension View {
    func saveAsImage(width: CGFloat, height: CGFloat, _ completion: @escaping (UIImage) -> Void) {
        let size = CGSize(width: width, height: height)

        let controller = UIHostingController(rootView: self.frame(width: width, height: height))
        controller.view.bounds = CGRect(origin: .zero, size: size)
        let image = controller.view.asImage()

        completion(image)
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        return renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }
}

extension UIScreen {
    var width: CGFloat { UIScreen.main.bounds.width }
    var height: CGFloat { UIScreen.main.bounds.height }
}

extension String {
   func replace(string:String, replacement:String) -> String {
       return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }

   func removeWhitespace() -> String {
       return self.replace(string: " ", replacement: "")
   }

    func getPhoneFormat() -> String {
        return self.filter("+0123456789".contains)
    }
 }

