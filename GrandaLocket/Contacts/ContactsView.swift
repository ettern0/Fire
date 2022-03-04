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
    let showNextStep: Bool

    private static var footerHeight: CGFloat {
        48 + 16 + 16 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0)
    }

    var sortedContacts: [ContactInfo] {
        let result = contacts.contacts.sorted {
            $0.status.order < $1.status.order
        }
        return result
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    ForEach(sortedContacts, id: \.phoneNumber) { contact in
                        ContactRow(contact: contact)
                            .listRowSeparator(.hidden)
                    }
                    Spacer()
                        .frame(height: Self.footerHeight)
                        .listRowSeparator(.hidden)
                }
                .animation(.default, value: contacts.contacts)
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Add your friends")
                .font(Typography.headerS)
                if showNextStep {
                    FooterNextView(destination: $destination, nextDestination: .main)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
