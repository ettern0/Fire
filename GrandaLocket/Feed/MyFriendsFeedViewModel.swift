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
