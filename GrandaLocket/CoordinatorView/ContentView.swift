//
//  ContentView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 15.02.2022.
//

import SwiftUI
import Firebase

struct ContentView: View {

    @State var destination: AppDestination = .phoneNumberAuth
    @State var phoneNumber: String = ""
    @State var syncContacts: Bool = true

    init() {
        if Auth.auth().currentUser?.uid != nil {
            _destination = State(initialValue: .onboarding)
        }
    }
    
    var body: some View {

        switch destination {
        case .onboarding:
            FooterSendView(destination: $destination, nextDestination: .onboarding)//TEST
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
