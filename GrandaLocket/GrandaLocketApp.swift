//
//  GrandaLocketApp.swift
//  GrandaLocket
//
//  Created by Alexey Salangin on 08.02.2022.
//

import SwiftUI
import Firebase

@main
struct GrandaLocketApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
//            FeedView()
            ContentView()
                .ignoresSafeArea()
        }
    }
}
