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

    var body: some View {
            VStack {
                Text("Find your friends")
                    .padding(.horizontal, 91)
                    .padding(.top, 101)
                    .foregroundColor(.white)
                    .font(Font.custom("ALSHauss-Regular", size: 24))
                    .multilineTextAlignment(.center)
                Spacer()
                Image("connectContacts")
                    .padding(.horizontal, 12)
                Spacer()
                Text("Connect Contacts")
                    .padding(.horizontal, 110)
                    .padding(.bottom, 8)
                    .foregroundColor(.white)
                    .font(Font.custom("ALSHauss-Regular", size: 18))
                    .multilineTextAlignment(.center)
                Text("See which of your Contacts are already on Houseparty. Add some friends to get started!")
                    .padding(.horizontal, 63)
                    .padding(.bottom, 40)
                    .foregroundColor(.white)
                    .font(Font.custom("ALSHauss-Regular", size: 16))
                    .multilineTextAlignment(.center)
                    .opacity(0.8)
                Button {
                    ContactsInfo.instance.requestAccessIfNeeded()
                    destination = .contacts
                } label: {
                    Text("NEXT")
                        .foregroundColor(.white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(UIColor(rgb: 0x92FFF8).color, lineWidth: 4)
                                .frame(width: 351, height: 58)
                        }
                }
                .frame(width: 343, height: 39)
                .padding(.horizontal, 16)
                .padding(.bottom, 60)
            }
            .frame(maxWidth: .infinity)
            .background(Color.black)
    }
}
