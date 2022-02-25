//
//  ContactGeneralFunctions.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 21.02.2022.
//

import Foundation

func getShortNameFromContact(firstName: String, lastName: String) ->String {

    let firstLetter: String
    let secondLetter: String

    if let ch = firstName.first {
        firstLetter = String(ch)
    } else {
        firstLetter = ""
    }

    if let ch = lastName.first {
        secondLetter = String(ch)
    } else {
        secondLetter = ""
    }

    return firstLetter + secondLetter

}
