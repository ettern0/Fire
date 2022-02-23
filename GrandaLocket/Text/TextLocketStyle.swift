//
//  TextLocketStyle.swift
//  GrandaLocket
//
//  Created by Alexey Salangin on 14.02.2022.
//

import Foundation
import SwiftUI
import UIKit

struct TextLocketStyle {
    let topGradient: LinearGradient
    let centerGradient: LinearGradient
    let bottomGradient: LinearGradient

    let id = UUID()
}

extension TextLocketStyle {
    static let violet: Self = .init(
        topGradient: LinearGradient(colors: [Color(rgb: 0x6E0DFF)], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        centerGradient: LinearGradient(colors: [Color(rgb: 0x5508C9)], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        bottomGradient: LinearGradient(colors: [Color(rgb: 0x6E0DFF)], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1))
    )

    static let black: Self = .init(
        topGradient: LinearGradient(colors: [Palette.widgetBlackLight], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        centerGradient: LinearGradient(colors: [Palette.blackHard], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        bottomGradient: LinearGradient(colors: [Palette.widgetBlackLight], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1))
    )

    static let orange: Self = .init(
        topGradient: LinearGradient(colors: [Palette.widgetOrangeLight], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        centerGradient: LinearGradient(colors: [Palette.widgetOrangeHard], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        bottomGradient: LinearGradient(colors: [Palette.widgetOrangeLight], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1))
    )

    static let pink: Self = .init(
        topGradient: LinearGradient(colors: [Palette.widgetPinkLight], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        centerGradient: LinearGradient(colors: [Palette.widgetPinkHard], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        bottomGradient: LinearGradient(colors: [Palette.widgetPinkLight], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1))
    )

    static let green: Self = .init(
        topGradient: LinearGradient(colors: [Palette.widgetGreenLight], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        centerGradient: LinearGradient(colors: [Palette.widgetGreenHard], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        bottomGradient: LinearGradient(colors: [Palette.widgetGreenLight], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1))
    )

    static let blue: Self = .init(
        topGradient: LinearGradient(colors: [Palette.widgetBlueLight], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        centerGradient: LinearGradient(colors: [Palette.widgetBlueHard], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        bottomGradient: LinearGradient(colors: [Palette.widgetBlueLight], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1))
    )

//    static let aquamarine: Self = .init(
//        topGradient: LinearGradient(colors: [Color(rgb: 0x005BEA)], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
//        centerGradient: LinearGradient(colors: [Color(rgb: 0x0160D5)], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
//        bottomGradient: LinearGradient(colors: [Color(rgb: 0x00C6FB)], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1))
//    )
}

extension TextLocketStyle: CaseIterable {
    static var allCases: [TextLocketStyle] {
        [.violet, .black, .orange, .pink, .green, .blue,]
    }
}
