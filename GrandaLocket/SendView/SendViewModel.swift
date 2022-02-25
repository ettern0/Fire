//
//  SendViewModel.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 23.02.2022.
//

import SwiftUI
import Combine

final class SendViewModel: ObservableObject {
    struct Friend: Hashable, Identifiable {
        let id: String?
        let firstName: String
        let lastName: String
        var isSelected: Bool = true
        let image: UIImage?
    }

    @Published var friends: [Friend] = []
    var cancellable: AnyCancellable?

    func selectAllFriends(value: Bool) {
        guard friends.contains(where: { $0.isSelected != value }) else { return }
        var friends = friends
        for index in friends.indices {
            friends[index].isSelected = value
        }
        self.friends = friends
    }

    init() {
        cancellable = ContactsInfo.instance.$contacts
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] contacts in
                guard let self = self else { return }
                let friends = contacts
                    .filter(\.isFriend)
                    .map { friend in
                        Friend(
                            id: friend.id,
                            firstName: friend.firstName,
                            lastName: friend.lastName,
                            isSelected: true,
                            image: friend.image
                        )
                    }
                self.friends = friends
            }
    }
}
