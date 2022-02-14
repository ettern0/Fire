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

extension LocketMode {
    var tintColor: Color {
        switch self {
        case .photo:
            return UIColor(rgb: 0x6E0DFF).color
        case .text:
            return UIColor(rgb: 0xFF7A00).color
        }
    }
}

enum GesturesDirection {
    case left, right, top, bottom
}
