//
//  ConnectContacts.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 16.02.2022.
//

import SwiftUI
import Contacts

struct ConnectContactsView: View {

    @Binding var destination: AppDestination
    let syncContacts: Bool

    init(destination: Binding<AppDestination>, syncContacts: Bool) {
        self._destination = destination
        self.syncContacts = syncContacts
    }

    var body: some View {
            VStack {
                Text("Find your friends")
                    .padding(.horizontal, 91)
                    .padding(.top, 101)
                    .foregroundColor(.white)
                    .font(Typography.headerL)
                    .multilineTextAlignment(.center)
                Spacer()
                Image("connectContacts")
                    .padding(.horizontal, 12)
                Spacer()
                Text("Connect Contacts")
                    .padding(.horizontal, 110)
                    .padding(.bottom, 8)
                    .foregroundColor(.white)
                    .font(Typography.headerS)
                    .multilineTextAlignment(.center)
                Text("See which of your Contacts are already on Fire. Add some friends to get started!")
                    .padding(.horizontal, 63)
                    .padding(.bottom, 40)
                    .foregroundColor(.white)
                    .font(Typography.description)
                    .multilineTextAlignment(.center)
                    .opacity(0.8)
                    .lineSpacing(4)
                FooterNextView(destination: $destination, nextDestination: .contacts)
            }
            .onAppear {
                if syncContacts == false {
                    self.destination = .main
                }
            }
            .frame(maxWidth: .infinity)
            .background(Palette.blackHard)
    }
}
