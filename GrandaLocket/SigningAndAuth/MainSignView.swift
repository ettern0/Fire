//
//  MainSignView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 14.02.2022.
//

import Foundation
import SwiftUI


struct MainSignView: View {

    @State var authMode: Bool = false
    @State var phoneNumber: String = ""
    @State var syncContacts: Bool = false

    var body: some View {
        if !authMode {
            SignView(syncContacts: $syncContacts, phoneNumber: $phoneNumber, authMode: $authMode)
        } else {
            AuthView(authMode: $authMode, phoneNumber: phoneNumber)
        }
    }
}
