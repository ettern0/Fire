//
//  Coordinator.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 15.02.2022.
//

import SwiftUI
import Coordinator

class AppCoordinator: UIWindowCoordinator<AppDestination> {
    override func transition(for route: AppDestination) -> ViewTransition {
        switch route {
        case .phoneNumberAuth:
            return .replace(with: MainView().ignoresSafeArea())
        case .smsAuth:
            return .push(Text("Second"))
        case .main:
            return .replace(with: MainView().ignoresSafeArea())
        case .feed:
            return .present(EmptyView())
        }
    }
}
