//
//  Typography.swift
//  GrandaLocket
//
//  Created by Аня on 17/02/22.
//

import UIKit
import SwiftUI

enum Typography {
    static let description = Font.alsHaussRegular(size: 16)
    static let descriptionS = Font.alsHaussRegular(size: 12)

    static let headerL = Font.alsHaussMedium(size: 28)
    static let headerM = Font.alsHaussMedium(size: 24)
    static let headerS = Font.alsHaussMedium(size: 18)

    static let controlL = Font.alsHaussMedium(size: 17)
    static let controlM = Font.alsHaussBold(size: 13)

    static let headerMUI = UIFont(name: "ALSHauss-Medium", size: 24)
    static let headerSUI = UIFont(name: "ALSHauss-Medium", size: 24)


}

extension Font {
    fileprivate static func alsHaussMedium(size: CGFloat) -> Font {
        let name = "ALSHauss-Medium"
        assert(UIFont(name: name, size: size) != nil)
        return Font.custom(name, size: size)
    }

    fileprivate static func alsHaussRegular(size: CGFloat) -> Font {
        let name = "ALSHauss-Regular"
        assert(UIFont(name: name, size: size) != nil)
        return Font.custom(name, size: size)
    }

    fileprivate static func alsHaussBold(size: CGFloat) -> Font {
        let name = "ALSHauss-Bold"
        assert(UIFont(name: name, size: size) != nil)
        return Font.custom(name, size: size)
    }

}
