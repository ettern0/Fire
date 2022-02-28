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

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        AppearanceConfigurator.configure()
        if let setting = Auth.auth().settings {
            setting.isAppVerificationDisabledForTesting = true
        }
        do {
            //get current user (so we can migrate later)
            let user = Auth.auth().currentUser
            //switch to using app group
            try Auth.auth().useUserAccessGroup("group.FirebaseAuth")
            //migrate current user
            if let user = user {
                Auth.auth().updateCurrentUser(user) { error in
                    //assertionFailure("User should not be nil.")
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return true
    }
}
