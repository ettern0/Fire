//
//  FireImageProvider.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 26.02.2022.
//

import Foundation
import SwiftUI
import Firebase

enum FireImageResponse {
    case Success(image: UIImage)
    case Failure
}

final class ImageProvider: ObservableObject {

    static  func getImageFromStorage(completion: @escaping (FireImageResponse) -> Void) {
        
        ImageService().download { photos in
            
            let reversedPhoto = photos.reversed()
            
            guard let user = try? Auth.auth().getStoredUser(forAccessGroup: "group.FirebaseAuth") else {
                assertionFailure("User should not be nil.")
                return
            }
            
            let friendsPhotos = reversedPhoto.filter {
                $0.authorID != user.uid
            }
            
            if let photo = friendsPhotos.first {
                self.loadImageFromData(url: photo.url, completion: completion)
            } else {
                return completion(.Failure)
            }
        }
    }
    
    static func loadImageFromData(url: URL, completion: @escaping (FireImageResponse) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(FireImageResponse.Success(image: image))
                    }
                }
            }
        }
    }
    
}
