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
    var status: ContactStatus
}

//Raw value for sorting in lists
enum ContactStatus: Int {
    case added = 0, request, register, none
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
            try CNContactStore().enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                if let phoneNumber = contact.phoneNumbers.first?.value {
                    UserService().checkUserStatusByPhone(phone: phoneNumber.stringValue) { status in
                        self.contacts.append(
                                ContactInfo(firstName: contact.givenName,
                                            lastName: contact.familyName,
                                            phoneNumber: phoneNumber.stringValue,
                                            status: status))
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

