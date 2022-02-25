//
//  FeedView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 22.02.2022.
//

import SwiftUI

struct FeedView: View {

    @Binding var destination: AppDestination
    @State private var yDirection: GesturesDirection = .bottom
    @ObservedObject var viewModel = FeedViewModel()
    private var minYToChangeMode: CGFloat {
        UIScreen.main.bounds.height * 0.1
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 40) {
                MyFeedView(viewModel: viewModel)
                MyFriendsFeedView(viewModel: viewModel, destination: $destination)
                Spacer()
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        changeyDirection(value.startLocation.y, value.location.y)
                        changeModeWithyDirection()
                    }
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button {
                        destination = .main
                    } label: {
                        VStack {
                            Image("angle_up")
                                .opacity(0.8)
                            Text("Camera")
                                .font(Typography.controlL)
                                .foregroundColor(.white)
                                .opacity(0.8)
                        }
                    }
                }
            }
        }
    }

    private func changeyDirection(_ yOld: CGFloat, _ yNew: CGFloat) {
        let dif = abs(yOld - yNew)
        if yOld < yNew, dif > minYToChangeMode {
            yDirection = .top
        } else if yOld > yNew, dif > minYToChangeMode {
            yDirection = .bottom
        }
    }

    private func changeModeWithyDirection() {
        withAnimation {
            if yDirection == .top {
                destination = .main
            }
        }
    }
}

private struct MyFriendsFeedView: View {
    @ObservedObject var viewModel: FeedViewModel
    @Binding var destination: AppDestination
    @ObservedObject private var contacts = ContactsInfo.instance

    var filteredContacts: [ContactInfo] {
        let request = contacts.contacts.filter { $0.status == .inContacts(.incomingRequest) }
        let result = request.sorted {
            $0.status.order < $1.status.order
        }
        return result
    }

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(showsIndicators: false) {
                HStack {
                    Text("My Friends")
                        .font(Typography.headerM)
                        .padding(.bottom, 20)
                    Spacer()
                    VStack() {
                        addButton
                        Spacer()
                    }
                }
                if filteredContacts.count > 0 {
                    requestList
                }
                ForEach(viewModel.friends, id: \.self) { friend in
                    if friend.url.count > 0 {
                        VStack(alignment: .leading) {
                            Text(friend.name)
                                .font(Typography.headerS)
                                .padding(.bottom, 20)
                            UserPhotosView(urls: friend.url)
                        }
                    }
                }
            }
        }
    }

    var requestList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Requests")
                .font(Typography.headerM)
                .padding(.bottom, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filteredContacts, id: \.phoneNumber) { contact in
                        VStack(spacing: 16) {
                            VStack(spacing: 8) {
                                ImageAvatar(image: contact.image, frame: CGSize(width: 70, height: 70))
                                Text(contact.firstName)
//                                    .frame(width: 70, height: 20)
                                    .font(Typography.description)
                                    .lineLimit(nil)
                            }
                            VStack(spacing: 8) {
                                acceptButton(contact: contact)
                                declineButton(contact: contact)
                            }
                        }
                    }
                }
            }
        }
        .padding(.bottom, 20)
    }

    var addButton: some View {
        Button {
            destination = .contacts
        } label: {
            Text("Add friends")
                .font(Typography.controlL)
                .foregroundColor(Palette.accent)
        }
    }

    struct acceptButton: View {
        var contact: ContactInfo
        var body: some View {
            Button {
                UserService().setRequestToChangeContactStatus(contact: contact) { status in }
            } label: {
                Text("ACCEPT")
            }
            .buttonStyle(SmallCapsuleButtonStyle())
            .frame(width: 95, height: 25)
        }
    }

    struct declineButton: View {
        var contact: ContactInfo
        var body: some View {
            Button {
                UserService().setRequestToDeleteContactStatus(contact: contact) { status in }
            } label: {
                Text("DECLINE")
                    .font(Typography.controlM)
                    .foregroundColor(Palette.whiteLight)
            }
            .buttonStyle(SmallDeclineCapsuleButtonStyle())
            .frame(width: 95, height: 25)
        }
    }
}

private struct MyFeedView: View {
    @ObservedObject var viewModel: FeedViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("My Fire")
                .font(Typography.headerM)
                .padding(.bottom, 20)
            UserPhotosView(urls: viewModel.myPhotos)
        }
    }
}

private struct UserPhotosView: View {
    let urls: Array<URL>
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(urls, id: \.self) { url in
                    NavigationLink(destination: GaleryView(urls: urls, focus: url)) {
                        AsyncImage(url: url) { image in
                            image
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .background(.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                }
            }
        }
    }
}
