//
//  ContentView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 15.02.2022.
//

import SwiftUI
import Coordinator
import Firebase

struct ContentView: View {
    
    @Coordinator(for: AppDestination.self) var coordinator
    @State var destination: AppDestination = .phoneNumberAuth
    @State var phoneNumber: String = ""
    @State var syncContacts: Bool = false
    
    var body: some View {
        switch destination {
        case .phoneNumberAuth:
            PhoneNumberView(syncContacts: $syncContacts, phoneNumber: $phoneNumber, destination: $destination)
        case .smsAuth:
            SmsView(destination: $destination, phoneNumber: phoneNumber)
        case .main:
            MainView()
        case .feed:
            EmptyView()
        }
    }
}
