//
//  ContactInfo.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 16.02.2022.
//

import Contacts

struct ContactInfo: Identifiable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var status: ContactStatus?
}

enum ContactStatus {
    case added, register
}

final class ContactsInfo {

    static let instance = ContactsInfo()
    var contacts: [ContactInfo]

    private init() {
        self.contacts = []
        self.requestAccess()
    }

    func fetchingContacts() {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do {
            try CNContactStore().enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                if let phoneNumber = contact.phoneNumbers.first?.value {

                    var status: ContactStatus?
                    UserService().checkUserStatusByPhone(phone: phoneNumber.stringValue) { value in
                        status = value
                    }

                    self.contacts.append(
                            ContactInfo(firstName: contact.givenName,
                                        lastName: contact.familyName,
                                        phoneNumber: phoneNumber.stringValue,
                                        status: status))
                }
            })
        } catch let error {
            print("Failed", error)
        }
        self.contacts = self.contacts.sorted {
            $0.firstName < $1.firstName
        }
    }

    func requestAccessIfNeeded() {
        
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

