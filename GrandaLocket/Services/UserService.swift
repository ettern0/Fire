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

    func checkUserStatusInContacts(phone: String, completion: @escaping (ContactStatus) -> Void) {
        db?.collection("contacts").whereField("phone", isEqualTo: phone.getPhoneFormat())
            .getDocuments() { (querySnapshot, err) in
                if err == nil {
                    if let snapshot = querySnapshot {
                        snapshot.documents.map { doc in
                            completion(ContactStatusFromString(doc["status"] as? String ?? ""))
                        }
                    }
                }
            }
    }
    
    func checkUserStatusByPhone(phone: String, completion: @escaping (ContactStatus) -> Void) {

        guard let db = db else {
            return completion(.notRegistered)
        }
        
        db.collection("users").whereField("phone", isEqualTo: phone.getPhoneFormat()).getDocuments(){ (querySnapshot, err) in
            if let snapshot = querySnapshot {
                snapshot.documents.first.map { doc in
                    completion(.isRegistered)
                }
            } else {

            }
        }
    }

    func setRequestToChangeContactStatus(contact: ContactInfo,
                                         completion: @escaping (ContactStatus) -> Void) {


        guard let user = Auth.auth().currentUser else {
            return
        }

        guard let phoneFrom = user.phoneNumber?.getPhoneFormat() else {
            return
        }

        var statusForChange: ContactStatus
        switch contact.status {
        case .isRegistered:
            statusForChange = .inContacts(.outcomingRequest)
        default:
            statusForChange = .notRegistered
        }

        let phoneTo = contact.phoneNumber.getPhoneFormat()
        let newValueTo = ["phone": phoneTo,
                    "status": statusForChange.stringValue]
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
