//
//  ContentView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 15.02.2022.
//

import SwiftUI
import Firebase

struct ContentView: View {

    @State var destination: AppDestination = .smsAuth
    @State var phoneNumber: String = "+16505551234"
    @State var syncContacts: Bool = true
    @State var snapshotImage: UIImage = UIImage()

    init() {
        if Auth.auth().currentUser?.uid != nil {
            _destination = State(initialValue: .main)
        }
    }
    
    var body: some View {
        Group {
            switch destination {
            case .onboarding:
                OnboardingView(destination: $destination)
            case .phoneNumberAuth:
                PhoneNumberView(syncContacts: $syncContacts, phoneNumber: $phoneNumber, destination: $destination)
            case .smsAuth:
                SmsView(destination: $destination, phoneNumber: phoneNumber)
            case .connectContacts:
                ConnectContactsView(destination: $destination, syncContacts: syncContacts)
            case .contacts:
                ContactsView(destination: $destination, showNextStep: true)
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
