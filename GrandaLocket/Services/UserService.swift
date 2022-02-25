//
//  UserService.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 17.02.2022.
//

import Foundation
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
            if let _ = err { }
            else { }
        }
    }

    func checkUserStatus(by phone: String, completion: @escaping (String?, ContactStatus) -> Void) {
        guard let db = db else {
            return completion(nil, .notRegistered)
        }
        
        db
            .collection("users")
            .whereField("phone", isEqualTo: phone.unformatted)
            .getDocuments()
        { [weak self] (querySnapshot, err) in
            if let document = querySnapshot?.documents.first {
                guard let self = self else { return }
                self.checkRegisteredUserStatus(by: phone, id: document.documentID, completion: completion)
            } else {
                completion(nil, .notRegistered)
            }
        }
    }

    private func checkRegisteredUserStatus(
        by phone: String,
        id: String,
        completion: @escaping (String?, ContactStatus) -> Void
    ) {
        guard let user = Auth.auth().currentUser else {
            assertionFailure("User should not be nil.")
            return completion(nil, .notRegistered)
        }

        let uid = user.uid

        db?.collection("contacts/\(uid)/contacts")
            .document(id)
            .getDocument() { (document, err) in
                if let document = document,
                   let rawStatus = document["status"] as? String {
                    let status = contactStatus(from: rawStatus)
                    completion(id, status)
                } else {
                    completion(id, .registered)
                }
            }
    }

    func setRequestToChangeContactStatus(contact: ContactInfo,
                                         completion: @escaping (ContactStatus) -> Void) {

        guard let user = Auth.auth().currentUser else {
            return
        }

        guard let phoneFrom = user.phoneNumber?.unformatted,
              let contactID = contact.id
        else {
            assertionFailure()
            return
        }

        let currentStatus = contact.status
        let (userStatus, friendStatus) = currentStatus.nextOnFriendRequest()

        let phoneTo = contact.phoneNumber.unformatted
        let userRequestFields = [
            "phone": phoneTo,
            "status": userStatus.stringValue
        ]
        let friendRequestField = [
            "phone": phoneFrom,
            "status": friendStatus.stringValue
        ]

        self.updateContactsFromRequest(id: user.uid, friendID: contactID, value: userRequestFields)
        self.updateContactsFromRequest(id: contactID, friendID: user.uid, value: friendRequestField)
        completion(userStatus)
    }

    private func updateContactsFromRequest(
        id: String,
        friendID: String,
        value: [String: String]
    ) {
        db?.collection("contacts").document(id).getDocument { (document, error) in
            if let document = document, document.exists {
                self.db?
                    .collection("contacts/\(id)/contacts")
                    .document(friendID)
                    .updateData(value)
            } else {
                self.db?
                    .collection("contacts/\(id)/contacts")
                    .document(friendID)
                    .setData(value)
            }
        }
    }

    func setRequestToDeleteContactStatus(contact: ContactInfo,
                                         completion: @escaping (Bool) -> Void) {

        guard let user = Auth.auth().currentUser else {
            return
        }

        guard let contactID = contact.id else {
            return
        }

        self.deleteContactsFromRequest(id: user.uid, friendID: contactID)
        self.deleteContactsFromRequest(id: contactID, friendID: user.uid)
        completion(true)
    }

    private func deleteContactsFromRequest(id: String, friendID: String) {
        db?.collection("contacts").document(id).collection("contacts").document(friendID).delete() { error in
        }
    }

    func addContactsListener(onUpdate: @escaping () -> Void) {
        guard let user = Auth.auth().currentUser else {
            return
        }

        db?.collection("contacts/\(user.uid)/contacts")
            .addSnapshotListener { documentSnapshot, error in
                guard documentSnapshot != nil else {
                    print("Error fetching document: \(error?.localizedDescription ?? "")")
                    return
                }
                onUpdate()
            }
    }
}
