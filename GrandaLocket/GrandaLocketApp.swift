//
//  GrandaLocketApp.swift
//  GrandaLocket
//
//  Created by Alexey Salangin on 08.02.2022.
//

import SwiftUI
import Firebase
import Coordinator

@main
struct GrandaLocketApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .coordinator(coordinator)
                .ignoresSafeArea()
        }
    }
}
