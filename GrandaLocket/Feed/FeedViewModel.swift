//
//  MyFriendsFeedViewModel.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 22.02.2022.
//

import Foundation
import Firebase
import Combine

final class FeedViewModel: ObservableObject {
    struct Friend: Hashable {
        var id: String?
        let name: String
        let phone: String
        var url: [URL]
    }

    @Published var friends: [Friend] = []
    @Published var myPhotos: Array<URL> = []
    private let service = DownloadImageService()
    private var cancellable: AnyCancellable?
    private var cancellablePhoto: AnyCancellable?

    init() {

        self.cancellable = ContactsInfo.instance.$contacts
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] contacts in
                guard let self = self else { return }
                let friendsModels = contacts.filter { $0.status == .inContacts(.friend) }
                self.friends  = friendsModels.map {
                    Friend(id: $0.id, name: $0.firstName, phone: $0.phoneNumber, url: [])
                }
            }

        self.cancellablePhoto = PhotosInfo.instance.$photos
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] photos in
                guard let self = self else { return }

                let reversedPhoto = photos.reversed()
                if let user = Auth.auth().currentUser {
                    let value = reversedPhoto.filter { $0.authorID == user.uid }
                    self.myPhotos = value.map { $0.url }
                }

                self.friends.forEach { friend in
                    let value = reversedPhoto.filter { $0.authorID == friend.id }
                    let url = value.map { $0.url }
                    if let friend = self.friends.first(where: { $0.id == friend.id}), let index = self.friends.firstIndex(of: friend) {
                        self.friends[index].url = url
                    }
                }
            }
    }
}
