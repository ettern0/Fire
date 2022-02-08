//
//  AppDelegate.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 08.02.2022.
//

import UIKit
import Firebase

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()

        return true
    }
}
