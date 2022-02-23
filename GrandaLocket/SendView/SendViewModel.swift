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
        let name: String
        var isSelected: Bool
    }

    @Published var friends: [Friend] = []
    var cancellable: AnyCancellable?

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
                            name: friend.firstName,
                            isSelected: false
                        )
                    }
                self.friends = friends
            }
    }
}
