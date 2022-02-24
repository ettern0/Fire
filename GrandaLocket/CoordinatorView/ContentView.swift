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
    @State var snapshotImage: UIImage = UIImage()

    init() {
        if Auth.auth().currentUser?.uid != nil {
            _destination = State(initialValue: .contacts)
        }
    }
    
    var body: some View {
        Group {
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
                MainView(destination: $destination, snapshotImage: $snapshotImage)
            case .send:
                SendView(destination: $destination, snapshotImage: $snapshotImage)
            case .feed:
                FeedView(destination: $destination)
            }
        }
        .animation(.default, value: destination)
    }
}
