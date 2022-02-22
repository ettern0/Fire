//
//  ContactRow.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 21.02.2022.
//

import SwiftUI

struct ContactRow: View {

    @ObservedObject private var contacts = ContactsInfo.instance
    var contact: ContactInfo
    var textForIcon: String {
        getShortNameFromContact(contact: contact)
    }

    var body: some View {

        HStack {
            Text("\(textForIcon)")
                .frame(width: 61, height: 61)
                .background {
                    Circle()
                        .stroke()
                        .foregroundColor(Palette.blackMiddle)
                }.padding(.trailing, 12)
            VStack(alignment: .leading, spacing: 8) {
                Text("\(contact.firstName) \(contact.lastName)")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
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
        case.registered:
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
