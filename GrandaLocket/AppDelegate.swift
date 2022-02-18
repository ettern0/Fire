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

        if let _ = Auth.auth().settings {
            //setting.isAppVerificationDisabledForTesting = true
        }

        return true
    }
}

enum AppearanceConfigurator {
    static func configure() {

        if let font = UIFont(name: "ALSHauss-Regular", size: 24) {
            UINavigationBar.appearance().largeTitleTextAttributes = [
                .font: font
            ]}

        if let font = UIFont(name: "ALSHauss-Regular", size: 17) {
        UINavigationBar.appearance().titleTextAttributes = [
            .font: font
        ]}
    }
}
