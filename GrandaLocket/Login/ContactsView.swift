//
//  ContactList.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 16.02.2022.
//

import SwiftUI

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
                            .listRowSeparator(.hidden)
                    }
                    .listRowBackground(Palette.blackHard)

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
                        .foregroundColor(Palette.accent)
                }.padding(.trailing, 12)
            VStack(alignment: .leading, spacing: 8) {
                Text("\(contact.firstName) \(contact.lastName)")
                    .foregroundColor(.white)
                    .font(Typography.description)
                    .lineSpacing(4)
                Text("\(contact.phoneNumber.stringValue)")
                    .foregroundColor(.white.opacity(0.8))
                    .font(Typography.description)
                    .lineSpacing(4)
            }
            Spacer()
            Button {
            } label: {
                Text("ADD")
            }.buttonStyle(SmallCapsuleButtonStyle())
        }
        .padding(.vertical, 10)
    }
}
