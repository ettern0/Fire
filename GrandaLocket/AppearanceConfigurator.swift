//
//  AppearanceConfigurator.swift
//  GrandaLocket
//
//  Created by Alexey Salangin on 23.02.2022.
//

import UIKit

enum AppearanceConfigurator {
    static func configure() {
        if let font = Typography.headerMUI {
            UINavigationBar.appearance().largeTitleTextAttributes = [
                .font: font
            ]
        }
        if let font = Typography.headerSUI {
            UINavigationBar.appearance().titleTextAttributes = [
                .font: font
            ]
        }
    }
}
