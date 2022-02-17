//
//  UIApplication+keyWindow.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 17.02.2022.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        // Get connected scenes
        let window = self.connectedScenes
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
        return window
    }
}
