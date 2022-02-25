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
        self.cancellable = Publishers.CombineLatest(ContactsInfo.instance.$contacts, PhotosInfo.instance.$photos)
            .receive(on: RunLoop.main)
            .removeDuplicates(by: { $0 == $1 })
            .sink { [weak self] contacts, photos in
                guard let self = self else { return }
                let reversedPhoto = photos.reversed()

                let friendsModels = contacts.filter { $0.status == .inContacts(.friend) }

                if let user = Auth.auth().currentUser {
                    let value = reversedPhoto.filter { $0.authorID == user.uid }
                    self.myPhotos = value.map { $0.url }
                }

                self.friends = friendsModels.map { friend in
                    let photos = reversedPhoto.filter { $0.authorID == friend.id }
                    let urls = photos.map { $0.url }
                    return Friend(id: friend.id, name: friend.firstName, phone: friend.phoneNumber, url: urls)
                }
            }

    }
}
