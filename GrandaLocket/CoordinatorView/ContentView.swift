//
//  ContentView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 15.02.2022.
//

import SwiftUI
import Firebase

struct ContentView: View {

    @State var destination: AppDestination = .contacts
    @State var phoneNumber: String = ""
    @State var syncContacts: Bool = false
    
    var body: some View {

        switch destination {
        case .onboarding:
            EmptyView()
        case .phoneNumberAuth:
            PhoneNumberView(syncContacts: $syncContacts, phoneNumber: $phoneNumber, destination: $destination)
        case .smsAuth:
            SmsView(destination: $destination, phoneNumber: phoneNumber)
        case .connectContacts:
            ConnectContactsView(destination: $destination)
        case .contacts:
            ContactsView(destination: $destination)
        case .main:
            MainView()
        case .feed:
            EmptyView()
        }
    }
}
