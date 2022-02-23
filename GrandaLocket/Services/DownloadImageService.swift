//
//  DownloadImageService.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 23.02.2022.
//

import Firebase

struct RemotePhoto {
    let url: URL
    let authorID: String
}

final class DownloadImageService {
    private let storage: Storage
    private let db: Firestore?

    init() {
        db = Firestore.firestore()
        storage = Storage.storage()
    }

    func download(completion: @escaping ([RemotePhoto]) -> Void) {
        guard let db = db else {
            return completion([])
        }

        guard let user = Auth.auth().currentUser else {
            assertionFailure("User should not be nil.")
            return completion([])
        }

        let uid = user.uid

        db.collection("user_images").document(uid).getDocument { [weak self] (document, error) in
            guard let self = self,
                  let document = document,
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
