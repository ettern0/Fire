//
//  UserService.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 17.02.2022.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserService {
    private let db: Firestore?

    init() {
        db = Firestore.firestore()
    }

    func saveUserData() {
        guard let user = Auth.auth().currentUser else {
            return
        }

        guard let phone = user.phoneNumber else {
            return
        }

        db?.collection("users").document(user.uid).setData([
            "phone": phone,
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }

    func checkUserStatusByPhone(phone: String, completion: @escaping (ContactStatus?) -> Void) {

        db?.collection("users").whereField("phone", isEqualTo: phone)
            .getDocuments() { (querySnapshot, err) in
                if let _ = err {
                    completion(nil)
                } else {
                    for _ in querySnapshot!.documents {
                        completion(.register)
                    }
                }
            }
    }

}
