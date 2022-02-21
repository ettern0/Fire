//
//  LocketMode.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 10.02.2022.
//

import Foundation
import SwiftUI

enum LocketMode: String, CaseIterable, Identifiable {
    case photo = "PHOTO"
    case text = "TEXT"

    var id: Self { self }

    mutating func toggle() {
        switch self {
        case .photo:
            self = .text
        case .text:
            self = .photo
        }
    }
}

enum GesturesDirection {
    case left, right, top, bottom
}
