//
//  ContactList.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 16.02.2022.
//

import SwiftUI

struct CarouselView: View {
    
    @ObservedObject private var contacts = ContactsInfo.instance
    @State var maxScale: CGFloat = 1
    let sizeOfstaticElement: CGFloat = 60
    let sizeOfScaledElement: CGFloat = 100
    let spacingHorizontal: CGFloat = 20
    var maxRatio: CGFloat {
        sizeOfScaledElement/sizeOfstaticElement
    }
    
    var filtredContacts: [ContactInfo] {
        contacts.contacts
//        contacts.contacts.filter {
//            $0.status == .inContacts(.friend)
//        }
    }

    var body: some View {
        GeometryReader { mainFrame in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(filtredContacts) { contact in
                        GeometryReader { geo in
                            CarouselContactView(contact: contact)
                                .scaleEffect(
                                    calcScale(mainFrame: mainFrame.frame(in: .global).maxX,
                                              minX: geo.frame(in: .global).minX))
                        }
                        .frame(width: sizeOfScaledElement + spacingHorizontal)
                    }
                }
                .position(x: 0, y: mainFrame.size.height)
            }
            .preferredColorScheme(.dark)
        }.frame(height: sizeOfScaledElement * 2)
    }

    private func calcScale(mainFrame: CGFloat, minX: CGFloat) -> CGFloat {
        let scale = minX/mainFrame
        var decreesRatio = abs(2 - (abs(0.5 - scale) * 2))
        if decreesRatio > maxRatio {
            decreesRatio = maxRatio
        } else if decreesRatio < 1 {
            decreesRatio = 1
        }
        return decreesRatio
    }
}

struct CarouselContactView: View {

    @ObservedObject private var contacts = ContactsInfo.instance
    var contact: ContactInfo
    var textForIcon: String {
        getShortNameFromContact(contact: contact)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                Circle()
                    .foregroundColor(.black.opacity(0.0001)) // https://stackoverflow.com/a/57157130
                    .frame(width: 60, height: 60)
                    .background {
                        Circle()
                            .stroke()
                            .foregroundColor(Palette.accent)
                    }
                    .background {
                        if contact.selected {
                            Image("selected")
                        }
                    }
                Text(contact.firstName)
                    .frame(width: 60, height: 20)
                    .font(Typography.descriptionS)
                    .lineLimit(nil)
            }
        }
        .onTapGesture {
            if let index = contacts.contacts.firstIndex(of: contact) {
                contacts.contacts[index].selected = !contact.selected
            }
        }
    }
}
