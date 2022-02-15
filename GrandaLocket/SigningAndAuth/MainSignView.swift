//
//  MainSignView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 14.02.2022.
//

import Foundation
import SwiftUI

enum AuthMode {
    case sign, auth, complete
}

struct MainSignView: View {

    @State var authMode: AuthMode = .auth
    @State var phoneNumber: String = "234234234"
    @State var syncContacts: Bool = false

    var body: some View {
        ZStack {
            if authMode == .sign {
                SignView(syncContacts: $syncContacts, phoneNumber: $phoneNumber, authMode: $authMode)
            } else if authMode == .auth {
                AuthView(authMode: $authMode, phoneNumber: phoneNumber)
            } else {
                PhotoView()
            }
        }.animation(.default, value: authMode)
    }
}
