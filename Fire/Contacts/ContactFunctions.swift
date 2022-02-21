//
//  ContactGeneralFunctions.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 21.02.2022.
//

import Foundation

func getShortNameFromContact(contact: ContactInfo) ->String {

    let firstLetter: String
    let secondLetter: String

    if let ch = contact.firstName.first {
        firstLetter = String(ch)
    } else {
        firstLetter = ""
    }

    if let ch = contact.lastName.first {
        secondLetter = String(ch)
    } else {
        secondLetter = ""
    }

    return firstLetter + secondLetter

}
