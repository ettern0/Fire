//
//  StorageManager.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 22.02.2022.
//

import SwiftUI
import Firebase

final class StorageManager: ObservableObject {

    private let storage: Storage
    private let db: Firestore?

    init() {
        db = Firestore.firestore()
        storage = Storage.storage()
    }

    func persistImageToStorage(image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            return
        }

        guard let data = image.jpegData(compressionQuality: 0.5) else {
            return completion(false)
        }

        let path: String = "\(user.uid ).\(UUID().uuidString).jpg"
        let ref = storage.reference().child(path)
        ref.putData(data, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("smth goes wrong")
                return completion(false)
            }
            ref.downloadURL { (url, error) in
                guard let url = url else {
                    print("smth goes wrong")
                    return completion(false)
                }
                self.saveImageToFirestore(url: url.absoluteString, completion: completion)
            }
        }
    }

    private func saveImageToFirestore(url: String, completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            return
        }

        db?.collection("images").document().setData([
            "url": url,
            "author": user.uid,
        ]) { err in
            if let _ = err {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
