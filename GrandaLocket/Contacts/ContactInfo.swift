//
//  ContactInfo.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 16.02.2022.
//

import Contacts
import Foundation
import UIKit

struct ContactInfo: Identifiable, Equatable {
    let id: String?
    let firstName: String
    let lastName: String
    let phoneNumber: String
    var status: ContactStatus
    let image: UIImage?

    mutating func changeStatus(_ status: ContactStatus) {
        self.status = status
    }
}

enum FriendStatus: Int {
    case incomingRequest, outcomingRequest, friend
}

enum ContactStatus: Equatable {
    case registered
    case notRegistered
    case inContacts(FriendStatus)

    var stringValue: String {
        switch self {
        case .registered:
            return "registered"
        case .notRegistered:
            return "notRegistered"
        case .inContacts(let friendStatus):
            switch friendStatus {
            case .incomingRequest:
                return "incomingRequest"
            case .outcomingRequest:
                return "outcomingRequest"
            case .friend:
                return "friend"
            }
        }
    }

    var order: Int {
        switch self {
        case .registered:
            return 4
        case .notRegistered:
            return 5
        case .inContacts(let friendStatus):
            switch friendStatus {
            case .incomingRequest:
                return 3
            case .outcomingRequest:
                return 2
            case .friend:
                return 1
            }
        }
    }

    // Возвращает статус дружбы, в который нужно перейти при нажатии на кнопку в списке контактов.
    // Первый аргумент - статус в таблице текущего пользователя, а второй - в таблице друга.
    func nextOnFriendRequest() -> (Self, Self) {
        switch self {
        case .registered:
            return (.inContacts(.outcomingRequest), .inContacts(.incomingRequest))
        case .notRegistered:
            return (.notRegistered, .notRegistered)
        case .inContacts(let friendStatus):
            switch friendStatus {
            case .incomingRequest:
                return (.inContacts(.friend), .inContacts(.friend))
            case .outcomingRequest:
                return (.inContacts(.outcomingRequest), .inContacts(.incomingRequest))
            case .friend:
                return (.inContacts(.friend), .inContacts(.friend))
            }
        }
    }
}

func contactStatus(from str: String) -> ContactStatus {
    switch str {
    case "friend":
        return .inContacts(.friend)
    case "incomingRequest":
        return .inContacts(.incomingRequest)
    case "outcomingRequest":
        return .inContacts(.outcomingRequest)
    case "register":
        return .registered
    case "notRegister":
        return .notRegistered
    default:
        return .notRegistered
    }
}

final class ContactsInfo: ObservableObject {
    static let instance = ContactsInfo()
    @Published var contacts: [ContactInfo]
    private let userService = UserService()
    private var isFetchingInProgress: Bool = false
    private var isFetchingPlanned: Bool = false

    private init() {
        self.contacts = []
        //self.requestAccess()
        fetchIfNeeded()

        userService.addContactsListener { [weak self] in
            self?.fetchIfNeeded()
        }
    }

    func fetchIfNeeded() {
        if isFetchingInProgress {
            isFetchingPlanned = true
        } else {
            fetchContactsInfo()
        }
    }

    private func fetchContactsInfo() {
        self.isFetchingInProgress = true
        self.isFetchingPlanned = false
        var internalContacts = [ContactInfo]()
        let contactsFromList = fetchContacts()
        var contactsPhones: [String] = []

        let dispatchGroup = DispatchGroup()
        contactsFromList.forEach { contact in
            contact.phoneNumbers.forEach { phone in
                if phone.value.stringValue.count > 10, !contact.givenName.isEmpty {//pass some services with short numbers and contacts without given name
                    contactsPhones.append(phone.value.stringValue.unformatted)
                    dispatchGroup.enter()
                    userService.checkUserStatus(by: phone.value.stringValue.unformatted) { (id, status) in

                        if status != .notRegistered {//only registered users
                            var image: UIImage?
                            if let imageData = contact.thumbnailImageData {
                                image = UIImage(data: imageData)
                            }

                            internalContacts.append(
                                ContactInfo(
                                    id: id,
                                    firstName: contact.givenName,
                                    lastName: contact.familyName,
                                    phoneNumber: phone.value.stringValue,
                                    status: status,
                                    image: image
                                )
                            )
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }

        dispatchGroup.enter()
        userService.getContactOutsideContactList(contactPhones: contactsPhones) { result in

            result.forEach { element in
                internalContacts.append(
                    ContactInfo(
                        id: element.id,
                        firstName: element.phone,
                        lastName: "",
                        phoneNumber: element.phone,
                        status: element.status,
                        image: nil
                    )
                )
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.contacts = internalContacts
            self.isFetchingInProgress = false
            if self.isFetchingPlanned {
                self.fetchIfNeeded()
            }
        }
    }

    private func fetchContacts() -> [CNContact] {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey, CNContactImageDataKey, CNContactThumbnailImageDataKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        var contacts: [CNContact] = []

        do {
            try CNContactStore().enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                if let _ = contact.phoneNumbers.first?.value {
                    contacts.append(contact)
                }
            })
        } catch let error {
            print("Failed", error)
        }

        return contacts.sorted {
            $0.givenName < $1.givenName
        }
    }
}

extension ContactInfo {
    var isFriend: Bool {
        status == .inContacts(.friend)
    }
}
