//
//  StorageManager.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 22.02.2022.
//

import SwiftUI
import Firebase

final class StorageManager: ObservableObject {

    let storage = Storage.storage()

    func persistImageToStorage(image: UIImage, completion: @escaping (String) -> Void) {
        guard let user = Auth.auth().currentUser else {
            return
        }

        guard let data = image.jpegData(compressionQuality: 0.5) else {
            return completion("")
        }

        let path: String = "\(user.uid ).\(UUID().uuidString).jpg"
        let ref = storage.reference().child(path)
        ref.putData(data, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("smth goes wrong")
                return completion("")
            }
            ref.downloadURL { (url, error) in
                guard let url = url else {
                    print("smth goes wrong")
                    return completion("")
                }
                return completion(url.absoluteString)
            }
        }
    }
}
