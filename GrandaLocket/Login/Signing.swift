//
//  MainSignView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 14.02.2022.
//

//import Firebase
//import Coordinator
//import SwiftUI
//
//enum AuthMode {
//    case sign, auth, complete
//}
//
//struct SigningView: View {
//
//    @State var authMode: AuthMode = .auth
//    @State var phoneNumber: String = "234234234"
//    @State var syncContacts: Bool = false
//    @Binding var destination: AppDestination
//
//    var body: some View {
//        ZStack {
//            if authMode == .sign {
//                PhoneNumberView(syncContacts: $syncContacts, phoneNumber: $phoneNumber, authMode: $authMode)
//            } else if authMode == .auth {
//                SmsView(authMode: $authMode, phoneNumber: phoneNumber, destination: destination)
//            } else {
//                MainView()
//            }
//        }.animation(.default, value: authMode)
//    }
//}
//
//struct SignView: View {
//
//    var body: some View {
//        VStack {
//            ProgressView()
//                .scaleEffect(1.5, anchor: .center)
//        }
//        .frame(maxHeight: .infinity)
//        .background(Color.black)
//        
//    }
//}
