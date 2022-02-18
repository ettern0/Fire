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

    func checkUserStatusByPhone(phone: String, completion: @escaping (ContactStatus) -> Void) {

        let filtredPhone = phone.filter("+0123456789".contains)
        db?.collection("users").whereField("phone", isEqualTo: filtredPhone)
            .getDocuments() { (querySnapshot, err) in
                if let _ = err {
                    completion(.none)
                } else {
                    for _ in querySnapshot!.documents {
                        completion(.register)
                    }
                }
            }
        completion(.none)
    }
}
