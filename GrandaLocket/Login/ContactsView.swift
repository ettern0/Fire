//
//  ContactList.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 16.02.2022.
//

import SwiftUI

struct ContactsView: View {

    @Binding var destination: AppDestination
    @ObservedObject private var contacts = ContactsInfo.instance

    private static var footerHeight: CGFloat {
        48 + 16 + 16 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0)
    }

    var sortedContacts: [ContactInfo] {
        contacts.contacts.sorted {
            $0.status.order < $1.status.order
        }
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    ForEach(sortedContacts) { contact in
                        ContactRow(contact: contact)
                            .listRowSeparator(.hidden)
                    }
                    .listRowBackground(Palette.blackHard)
                    Spacer()
                        .frame(height: Self.footerHeight)
                }
                .animation(.default, value: contacts.contacts)
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Add your friends")
                FooterView(destination: $destination, nextDestination: .main)
            }.ignoresSafeArea(edges: .bottom)
        }.preferredColorScheme(.dark)
    }
}

private struct ContactRow: View {

    @ObservedObject private var contacts = ContactsInfo.instance
    var contact: ContactInfo

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
                Text("\(contact.phoneNumber)")
                    .foregroundColor(.white.opacity(0.8))
                    .font(Typography.description)
                    .lineSpacing(4)
            }
            Spacer()

            let buttonProperties = getTextButtonPropeties()

            Button {
                UserService().setRequestToChangeContactStatus(contact: contact) { status in
                    if let index = contacts.contacts.firstIndex(of: contact) {
                        contacts.contacts[index].status = status
                    }
                }
            } label: {
                buttonProperties.label
            }
            .buttonStyle(SmallCapsuleButtonStyle())
            .disabled(buttonProperties.disabled)
        }
        .padding(.vertical, 10)
    }

    private func getTextButtonPropeties() -> (label: AnyView, disabled: Bool) {
        switch contact.status {
        case.isRegistered:
            return (label: AnyView(Text("ADD")), disabled: false)
        case .notRegistered:
            return (label: AnyView(Text("INVITE")), disabled: false)
        case .inContacts(.friend):
            return (label: AnyView(Text("ADDED")), disabled: true)
        case .inContacts(.outcomingRequest):
            return (label: AnyView(Text("REQUEST")), disabled: false)
        case .inContacts(.incomingRequest):
            return (label: AnyView(Text("APPLY")), disabled: false)
        }
    }
}
