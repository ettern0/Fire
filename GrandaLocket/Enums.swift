
import Foundation

enum Modes: String, CaseIterable, Identifiable {
    case photo = "PHOTO"
    case text = "TEXT"

    var id: Self { self }
}
