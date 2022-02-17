//
//  Typography.swift
//  GrandaLocket
//
//  Created by Аня on 17/02/22.
//

import UIKit
import SwiftUI

enum Typography {
    static let description = Font.alsHaussMedium(size: 16)

    static let headerL = Font.alsHaussMedium(size: 28)
    static let headerM = Font.alsHaussMedium(size: 24)
    static let headerS = Font.alsHaussMedium(size: 18)

    static let controlL = Font.alsHaussMedium(size: 17)
    static let controlM = Font.alsHaussMedium(size: 13)
}

extension Font {
    fileprivate static func alsHaussMedium(size: CGFloat) -> Font {
        let name = "ALSHauss-Medium"
        assert(UIFont(name: name, size: size) != nil)
        return Font.custom(name, size: size)
    }
}
