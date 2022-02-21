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
                snapshot.documents.map { doc in
                    completion(.isRegistered)
                }
            } else {

            }
        }
    }

    func setRequestToChangeContactStatus(contact: ContactInfo,
                                         completion: @escaping (ContactStatus) -> Void) {

        var statusForChange: ContactStatus
        switch contact.status {
        case .isRegistered:
            statusForChange = .inContacts(.outcomingRequest)
        default:
            statusForChange = .notRegistered
        }

        //Try to save data in your contacts lis Firebase with current status
        let request = db?.collection("contacts").whereField("phone", isEqualTo: contact.phoneNumber.getPhoneFormat())
        let requestToUpdate = db?.collection("contacts").document(contact.id.uuidString)

        //First try to check if the number already exist and update
        request?.getDocuments() { (querySnapshot, err) in
            if let _ = err {
                completion(contact.status)
            } else {
                for _ in querySnapshot!.documents {
                    //Update data
                    requestToUpdate?.updateData([
                        "status": statusForChange.stringValue
                    ]) { err in
                        if let _ = err {
                            completion(contact.status)
                        }
                        else {
                            completion(statusForChange)
                        }
                    }
                }
            }
        }

        //Second try to create new entity in contacts Forebase
        requestToUpdate?.setData([
            "phone": contact.phoneNumber.getPhoneFormat(),
            "status": statusForChange.stringValue
        ]) { err in
            if let _ = err {
                completion(contact.status)
            }
            else {
                completion(statusForChange)
            }
        }
    }
}