//
//  FirebaseService.swift
//  Widget ExtensionExtension
//
//  Created by Сердюков Евгений on 27.02.2022.
//

import Foundation
import Firebase
import FirebaseFirestore

struct RemotePhoto: Equatable {
    let url: URL
    let authorID: String
}

final class ImageService {
    private let db: Firestore?

    init() {
        db = Firestore.firestore()
    }

    func download(completion: @escaping ([RemotePhoto]) -> Void) {
        guard let db = db else {
            return completion([])
        }

        guard let user = try? Auth.auth().getStoredUser(forAccessGroup: "group.com.magauran.fire") else {
            return completion([])
        }

        let uid = user.uid

        db.collection("user_images").document(uid).getDocument { (document, error) in
            guard let document = document,
                  let images = document["images"] as? [String]
            else {
                return completion([])
            }

            self.fetchPhotosProperties(photoIDs: images, completion: completion)
        }

    }

    private func fetchPhotosProperties(photoIDs: [String], completion: @escaping ([RemotePhoto]) -> Void) {
        let dispatchGroup = DispatchGroup()

        var photos: [RemotePhoto?] = Array(repeatElement(nil, count: photoIDs.count))

        photoIDs.enumerated().forEach { offset, id in
            dispatchGroup.enter()
            self.fetchPhotoProperties(photoID: id) { photo in
                dispatchGroup.leave()
                photos[offset] = photo
            }
        }

        dispatchGroup.notify(queue: .global()) {
            let unwrappedPhotos = photos.compactMap { $0 }
            completion(unwrappedPhotos)
        }
    }

    private func fetchPhotoProperties(photoID: String, completion: @escaping (RemotePhoto?) -> Void) {
        guard let db = db else {
            return completion(nil)
        }

        db.collection("images").document(photoID).getDocument { (document, error) in
            guard let document = document,
                  let urlString = document["url"] as? String,
                  let url = URL(string: urlString),
                  let author = document["author"] as? String
            else {
                return completion(nil)
            }

            let photo = RemotePhoto(url: url, authorID: author)
            completion(photo)
        }
    }
}
