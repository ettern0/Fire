//
//  ContactList.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 16.02.2022.
//

import SwiftUI
import Contacts

struct ContactsView: View {

    @Binding var destination: AppDestination
    let allContacts = ContactsInfo.instance.contacts
    private static var footerHeight: CGFloat {
        48 + 16 + 16 + (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0)
    }

    init(destination: Binding<AppDestination>) {
        self._destination = destination
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    ForEach(allContacts) { contact in
                        ContactRow(contact: contact)
                    }
                    .listRowBackground(Color.black)
                    Spacer()
                        .frame(height: Self.footerHeight)
                }
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Add your friends")
                FooterView(destination: $destination, nextDestination: .main)
            }.ignoresSafeArea(edges: .bottom)
        }.preferredColorScheme(.dark)
    }
}

private struct ContactRow: View {
    let contact: ContactInfo
    var body: some View {
        HStack {
            VStack() {
                Text("\(contact.firstName) \(contact.lastName)")
                    .foregroundColor(.white)
                    .font(Font.custom("ALSHauss-Regular", size: 16))
                    .multilineTextAlignment(.trailing)
                Text("\(contact.phoneNumber.stringValue)")
                    .foregroundColor(.white)
                    .font(Font.custom("ALSHauss-Regular", size: 16))
                    .multilineTextAlignment(.trailing)
                    .opacity(0.8)
                Spacer()
            }
            Spacer()
            Button {

            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 60, height: 25)
                    .foregroundColor(UIColor(rgb: 0xA6CFE2).color)
                    .overlay {
                        Text("ADD")
                            .font(Font.custom("ALSHauss-Regular", size: 13))
                            .foregroundColor(.black)
                    }
            }
        }

    }
}
