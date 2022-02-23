//
//  MyFriendsFeedViewModel.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 22.02.2022.
//

import Foundation
import Combine

final class MyFriendsFeedViewModel: ObservableObject {
    struct Friend: Hashable {
        let name: String
        let phone: String
        let lockets: [String]
    }

    @Published
    var friends: [Friend] = []

    private var cancellable: AnyCancellable?

    init() {
        self.cancellable = ContactsInfo.instance.$contacts
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] contacts in
                guard let self = self else { return }
                let friendsModels = contacts.filter { $0.status == .inContacts(.friend) }
                let friends = friendsModels.map {
                    Friend(name: $0.firstName, phone: $0.phoneNumber, lockets: [])
                }
                self.friends = friends
            }
    }
}
