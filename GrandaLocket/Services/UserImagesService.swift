//
//  StorageManager.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 22.02.2022.
//

import SwiftUI
import Firebase

final class UserImagesService: ObservableObject {
    private let storage: Storage
    private let db: Firestore?

    init() {
        db = Firestore.firestore()
        storage = Storage.storage()
    }

    func send(
        image: UIImage,
        to friendsIDs: [String],
        completion: @escaping (Bool) -> Void
    ) {
        guard let user = Auth.auth().currentUser else {
            return completion(false)
        }
        let uid = user.uid

        self.uploadImageToStorage(image) { url in
            guard let url = url else {
                return completion(false)
            }

            self.saveImageToImages(authorID: uid, url: url.absoluteString) { documentID in
                guard let documentID = documentID else {
                    return completion(false)
                }

                let dispatchGroup = DispatchGroup()

                friendsIDs.forEach { id in
                    dispatchGroup.enter()
                    self.saveImageToUserImages(userID: id, imageID: documentID) {
                        dispatchGroup.leave()
                    }
                }

                do {
                    dispatchGroup.enter()
                    self.saveImageToUserImages(userID: uid, imageID: documentID) {
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .global()) {
                    completion(true)
                }
            }
        }
    }

    private func uploadImageToStorage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            return completion(nil)
        }

        let path: String = UUID().uuidString
        let ref = storage.reference().child(path)
        ref.putData(data, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("smth goes wrong")
                return completion(nil)
            }
            ref.downloadURL { (url, error) in
                completion(url)
            }
        }
    }

    private func saveImageToImages(authorID: String, url: String, completion: @escaping (String?) -> Void) {
        let imageRef = db?.collection("images").document()
        let data = [
            "url": url,
            "author": authorID,
        ]
        imageRef?.setData(data, merge: true, completion: { _ in
            completion(imageRef?.documentID)
        })
    }

    private func saveImageToUserImages(
        userID: String,
        imageID: String,
        completion: @escaping () -> Void
    ) {
        guard let collection = db?.collection("user_images") else {
            return completion()
        }
        collection.document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                collection.document(userID).updateData([
                    "images": FieldValue.arrayUnion([imageID])
                ]) { _ in
                    completion()
                }
            } else {
                collection.document(userID).setData([
                    "images": [imageID]
                ]) { _ in
                    completion()
                }
            }
        }
    }
}
