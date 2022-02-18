//
//  ContactInfo.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 16.02.2022.
//

import Contacts
import Foundation

struct ContactInfo: Identifiable, Equatable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var status: ContactStatus

    mutating func changeStatus(_ status: ContactStatus) {
        self.status = status
    }
}

//Raw value for sorting in lists
enum ContactStatus: Int {
    case added = 0, request, register, notRegister

    func stringValue() -> String {
        return String(describing: self)
    }
}

func ContactStatusFromString(_ str: String) -> ContactStatus {
    switch str {
    case "added":
        return .added
    case "request":
        return .request
    case "register":
        return .register
    case "notRegister":
        return .notRegister
    default:
        return .notRegister
    }
}

final class ContactsInfo: ObservableObject {

    static let instance = ContactsInfo()
    @Published var contacts: [ContactInfo]

    private init() {
        self.contacts = []
        self.requestAccess()
    }

    func fetchingContacts() {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do {

            let group = DispatchGroup()

            try CNContactStore().enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                if let phoneNumber = contact.phoneNumbers.first?.value {

                    //Try to find status in contacts
                    group.enter()
                    UserService().checkUserStatusInContacts(phone: phoneNumber.stringValue) { status in
                        self.contacts.append(
                            ContactInfo(firstName: contact.givenName,
                                        lastName: contact.familyName,
                                        phoneNumber: phoneNumber.stringValue,
                                        status: status))
                        group.leave()
                    }

                    //Try to find if registered in app
                    group.enter()
                    UserService().checkUserStatusByPhone(phone: phoneNumber.stringValue) { status in
                        self.contacts.append(
                            ContactInfo(firstName: contact.givenName,
                                        lastName: contact.familyName,
                                        phoneNumber: phoneNumber.stringValue,
                                        status: status))
                        group.leave()
                    }

                    //add to array
                    group.notify(queue: DispatchQueue.global()) {
                        self.contacts.append(
                            ContactInfo(firstName: contact.givenName,
                                        lastName: contact.familyName,
                                        phoneNumber: phoneNumber.stringValue,
                                        status: .notRegister))
                    }
                }
            })
        } catch let error {
            print("Failed", error)
        }
        self.contacts = self.contacts.sorted {
            $0.firstName < $1.firstName
        }
    }

    func requestAccess() {
        let store = CNContactStore()
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            self.fetchingContacts()
        case .denied:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    self.fetchingContacts()
                }
            }
        case .restricted, .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    self.fetchingContacts()
                }
            }
        @unknown default:
            print("error")
        }
    }
}

