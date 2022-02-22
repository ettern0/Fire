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

    func checkRegisteredUserStatus(by phone: String, completion: @escaping (ContactStatus) -> Void) {
        guard let user = Auth.auth().currentUser else {
            assertionFailure("User should not be nil.")
            return completion(.notRegistered)
        }
        
        db?.collection("contacts")
            .document(user.uid)
            .getDocument() { (document, err) in
                if let document = document,
                   let contacts = document["contacts"] as? [[String: String]],
                   let contact = contacts.first(where: { $0["phone"] == phone.unformatted }),
                   let rawStatus = contact["status"] {
                    let status = contactStatus(from: rawStatus)
                    completion(status)
                } else {
                    completion(.registered)
                }
            }
    }
    
    func checkUserStatus(by phone: String, completion: @escaping (ContactStatus) -> Void) {
        guard let db = db else {
            return completion(.notRegistered)
        }
        
        db
            .collection("users")
            .whereField("phone", isEqualTo: phone.unformatted)
            .getDocuments()
        { [weak self] (querySnapshot, err) in
            if (querySnapshot?.documents.first) != nil {
                guard let self = self else { return }
                self.checkRegisteredUserStatus(by: phone, completion: completion)
            } else {
                completion(.notRegistered)
            }
        }
    }

    func setRequestToChangeContactStatus(contact: ContactInfo,
                                         completion: @escaping (ContactStatus) -> Void) {

        guard let user = Auth.auth().currentUser else {
            return
        }

        guard let phoneFrom = user.phoneNumber?.unformatted else {
            return
        }

        let phoneTo = contact.phoneNumber.unformatted
        let newValueTo = ["phone": phoneTo,
                          "status": ContactStatus.inContacts(.outcomingRequest).stringValue]
        let newValueFrom = ["phone": phoneFrom,
                            "status": ContactStatus.inContacts(.incomingRequest).stringValue]

        db?.collection("contacts").document(user.uid).getDocument { (document, error) in
            self.updateContactsFromRequest(id: user.uid, value: newValueTo)
        }

        // Request to update info in request number
        db?
            .collection("users")
            .whereField("phone", isEqualTo: phoneTo)
            .getDocuments() { (snapshot, error) in
                if let snapshot = snapshot, let document = snapshot.documents.first {
                    self.updateContactsFromRequest(id: document.documentID, value: newValueFrom)
                    completion(ContactStatus.inContacts(.outcomingRequest))
                } else {
                    assertionFailure("User doesnt exist")
                }
            }
    }

    private func updateContactsFromRequest(id: String,
                                      value: [String: String]) {
        db?.collection("contacts").document(id).getDocument { (document, error) in
            if let document = document, document.exists {
                self.db?.collection("contacts").document(id).updateData([
                    "contacts": FieldValue.arrayUnion([value])
                ])
            } else {
                self.db?.collection("contacts").document(id).setData([
                    "contacts": [value]
                ])
            }
        }
    }
}
