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

    init(destination: Binding<AppDestination>) {
        self._destination = destination
        UITableViewCell.appearance().backgroundColor = .black
        UITableView.appearance().backgroundColor = .black
    }

    var body: some View {
        ZStack {
            VStack {
                Text("Add your friends")
                    .padding(.horizontal, 93)
                    .padding(.top, 101)
                    .padding(.bottom, 8)
                    .foregroundColor(.white)
                    .font(Font.custom("ALSHauss-Regular", size: 24))
                    .multilineTextAlignment(.center)
                Text("Your friend in Fire")
                    .padding(.horizontal, 63)
                    .padding(.bottom, 24)
                    .foregroundColor(.white)
                    .font(Font.custom("ALSHauss-Regular", size: 16))
                    .multilineTextAlignment(.center)
                    .opacity(0.8)
                List {
                    ForEach(allContacts) { contact in
                        ContactRow(contact: contact)
                    }
                    .listRowBackground(Color.black)
                }
            }
            .ignoresSafeArea()
            .frame(maxWidth: .infinity)
            .background(Color.black)
//        ZStack {
//            VStack {
//                Spacer()
//                Rectangle()
//                    .frame(width: 375, height: 130)
//                    .opacity(0.8)
//                    .blur(radius: 1)
//            }
//            .frame(maxWidth: .infinity)
//            .background(Color.black)
//            VStack {
//                Spacer()
//                Button {
//                    ContactsInfo.instance.requestAccessIfNeeded()
//                    destination = .main
//                } label: {
//                    Text("NEXT")
//                        .foregroundColor(.white)
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 16)
//                                .stroke(UIColor(rgb: 0x92FFF8).color, lineWidth: 4)
//                                .frame(width: 351, height: 58)
//                        }
//                }
//                .frame(width: 343, height: 39)
//                .padding(.horizontal, 16)
//                .padding(.bottom, 60)
//            }
//            .frame(maxWidth: .infinity)
//            .background(Color.black)
//        }
        }
    }
}

private struct ContactRow: View {
    var contact: ContactInfo
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
