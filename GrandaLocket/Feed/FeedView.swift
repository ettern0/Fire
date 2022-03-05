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
    @State var showContacts: Bool = false
    private var minYToChangeMode: CGFloat {
        UIScreen.main.bounds.height * 0.1
    }


    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                MyFeedView(viewModel: viewModel, destination: $destination)
                    .padding(.bottom, 40)
                MyFriendsFeedView(viewModel: viewModel, destination: $destination, showContacts: $showContacts)
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
    @Binding var showContacts: Bool

    var filteredContacts: [ContactInfo] {
        let request = contacts.contacts.filter { $0.status == .inContacts(.incomingRequest) }
        let result = request.sorted {
            $0.status.order < $1.status.order
        }
        return result
    }

    var body: some View {
        VStack(alignment: .leading) {
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

    var requestList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Requests")
                .font(Typography.headerS)
                .padding(.bottom, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filteredContacts, id: \.phoneNumber) { contact in
                        VStack(spacing: 16) {
                            VStack(spacing: 8) {
                                ImageAvatar(image: contact.image, frame: CGSize(width: 70, height: 70))
                                Text(contact.firstName)
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
            showContacts.toggle()
            //destination = .contacts
        } label: {
            Text("Add friends")
                .font(Typography.controlL)
                .foregroundColor(Palette.accent)
        }
        .sheet(isPresented: $showContacts) {
            ContactsView(destination: $destination, showNextStep: false)
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

import Firebase

private struct MyFeedView: View {
    @ObservedObject var viewModel: FeedViewModel
    @Binding var destination: AppDestination

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("My Fire")
                    .font(Typography.headerM)
                Spacer()
  //              signOutButton
            }
            .padding(.bottom, 20)
            UserPhotosView(urls: viewModel.myPhotos)

        }
    }

    var signOutButton: some View {
        Button {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                destination = .phoneNumberAuth
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        } label: {
            Text("Sign out")
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
