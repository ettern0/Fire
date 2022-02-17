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

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        FirebaseApp.configure()

        AppearanceConfigurator.configure()

        if let setting = Auth.auth().settings {
            //setting.isAppVerificationDisabledForTesting = true
        }

        return true
    }
}

enum AppearanceConfigurator {
    static func configure() {
        UIFont.familyNames.forEach({ familyName in
                    let fontNames = UIFont.fontNames(forFamilyName: familyName)
                    print(familyName, fontNames)
                })
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont(name: "ALSHauss-Regular", size: 24)
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont(name: "ALSHauss-Regular", size: 17)
        ]
    }
}
