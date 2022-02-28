//
//  Palette.swift
//  GrandaLocket
//
//  Created by Аня on 16/02/22.
//

import SwiftUI

enum Palette {
    static let blackHard = Color(rgb: 0x110E15)
    static let blackMiddle = Color(rgb: 0x252525)
    static let blackLight = Color(rgb: 0x6B6B6B)
    static let blackOpacity = Color(rgb: 0x000000).opacity(0.4)

    static let whiteHard = Color(rgb: 0xFFFFFF)
    static let whiteMiddle = Color(rgb: 0xFFFFFF).opacity(0.8)
    static let whiteLight = Color(rgb: 0xFFFFFF).opacity(0.6)
    static let whiteOpacity = Color(rgb: 0xFFFFFF).opacity(0.06)

    static let accent = Color(rgb: 0xCFF308)

    static let widgetGreenLight = Color(rgb: 0x23A566)
    static let widgetGreenHard = Color(rgb: 0x1E8B57)
    static let widgetOrangeLight = Color(rgb: 0xFF6B00)
    static let widgetOrangeHard = Color(rgb: 0xED4903)
    static let widgetPinkLight = Color(rgb: 0xDD0DFF)
    static let widgetPinkHard = Color(rgb: 0xB70AD3)
    static let widgetBlueLight = Color(rgb: 0x0D7CFF)
    static let widgetBlueHard = Color(rgb: 0x0662CD)
    static let widgetVioletLight = Color(rgb: 0x6E0DFF)
    static let widgetVioletHard = Color(rgb: 0x5508C9)
    static let widgetGradientLight = LinearGradient(
        colors: [.init(rgb: 0x005BEA), .init(rgb: 0x00C6FB)],
        startPoint: .init(x: 0, y: 0),
        endPoint: .init(x: 1, y: 1))
    static let widgetGradientHard = Color(rgb: 0x000000).opacity(0.1)
    static let widgetBlackLight = Color(rgb: 0x2A272E)
    static let widgetBlackHard = Color(rgb: 0x1B1A1D)
}
