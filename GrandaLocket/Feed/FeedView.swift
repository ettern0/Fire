//
//  FeedView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 22.02.2022.
//

import SwiftUI

struct FeedView: View {

    //@Binding var destination: AppDestination

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                MyFeedView()
                MyFriendsFeedView()

                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button {
                        // destination = .main
                    } label: {
                        VStack {
                            Image("angle_up")
                                .opacity(0.8)
                            Text("Camera")
                                .font(Typography.controlL)
                        }
                    }
                }
            }
        }
    }
}

import Combine

final class MyFriendsFeedViewModel: ObservableObject {
    struct Friend: Hashable {
        let name: String
        let lockets: [String]
    }

    @Published
    var friends: [Friend] = []

    private var cancellable: AnyCancellable?

    init() {
        self.cancellable = ContactsInfo.instance.$contacts.sink { [weak self] contacts in
            guard let self = self else { return }
            let friendsModels = contacts.filter { $0.status == .inContacts(.friend) }
            let friends = friendsModels.map { Friend(name: $0.firstName, lockets: []) }
            self.friends = friends
        }
    }
}

private struct MyFriendsFeedView: View {
    @ObservedObject private var viewModel = MyFriendsFeedViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text("My Friends")
                .font(Typography.headerM)
                .padding(.bottom, 20)
            ForEach(viewModel.friends, id: \.self) { friend in
                Text(friend.name)
                if friend.lockets.isEmpty {
                    Text("Душнила-друг ничего тебе не послал")
                } else {
                    Text("Посты любимого друга")
                }
            }
        }
    }
}

private struct MyFeedView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("My Fire")
                .font(Typography.headerM)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    Image("example")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Image("example")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Image("example")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Image("example")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Image("example")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Image("example")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            }
        }
    }
}
