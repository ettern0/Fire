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
                    .listRowBackground(Palette.blackHard)
                    Spacer()
                        .frame(height: Self.footerHeight)
                }
                .animation(.default, value: contacts.contacts)
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .background(Palette.blackHard)
                .navigationTitle("Add your friends")
                .font(Typography.headerS)
                FooterNextView(destination: $destination, nextDestination: .main)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
