
import Foundation
import SwiftUI

enum LocketMode: String, CaseIterable, Identifiable {
    case photo = "PHOTO"
    case text = "TEXT"

    var id: Self { self }

    mutating func changeMode() {
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
