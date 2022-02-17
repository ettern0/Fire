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
        48 + 16 + 16 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0)
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
    var textForIcon: String {

        let firstLetter: String
        let secondLetter: String

        if let ch = contact.firstName.first {
            firstLetter = String(ch)
        } else {
            firstLetter = ""
        }

        if let ch = contact.lastName.first {
            secondLetter = String(ch)
        } else {
            secondLetter = ""
        }

        return firstLetter + secondLetter
    }

    var body: some View {

        HStack {
            Text("\(textForIcon)")
                .frame(width: 61, height: 61)
                .background {
                    Circle()
                        .stroke()
                        .foregroundColor(Color(rgb: 0x92FFF8))
                }
            VStack(alignment: .leading) {
                Text("\(contact.firstName) \(contact.lastName)")
                    .foregroundColor(.white)
                    .font(Font.custom("ALSHauss-Regular", size: 16))
                Text("\(contact.phoneNumber.stringValue)")
                    .foregroundColor(.white)
                    .font(Font.custom("ALSHauss-Regular", size: 16))
                    .opacity(0.8)
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
