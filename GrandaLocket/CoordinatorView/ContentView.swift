//
//  ContentView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 15.02.2022.
//

import SwiftUI
import Firebase

struct ContentView: View {

    @State var destination: AppDestination = .connectContacts
    @State var phoneNumber: String = ""
    @State var syncContacts: Bool = true

    init() {
        if Auth.auth().currentUser?.uid != nil {
            destination = .contacts
        }
    }
    
    var body: some View {

        switch destination {
        case .onboarding:
            EmptyView()
        case .phoneNumberAuth:
            PhoneNumberView(syncContacts: $syncContacts, phoneNumber: $phoneNumber, destination: $destination)
        case .smsAuth:
            SmsView(destination: $destination, phoneNumber: phoneNumber)
        case .connectContacts:
            ConnectContactsView(destination: $destination, syncContacts: syncContacts)
        case .contacts:
            ContactsView(destination: $destination)
        case .main:
            MainView()
        case .feed:
            EmptyView()
        }
    }
}
