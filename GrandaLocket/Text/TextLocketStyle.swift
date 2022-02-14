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
}

extension TextLocketStyle {
    static let black: Self = .init(
        topGradient: LinearGradient(colors: [UIColor(rgb: 0x2A272E).color], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        centerGradient: LinearGradient(colors: [UIColor(rgb: 0x1B1A1D).color], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1)),
        bottomGradient: LinearGradient(colors: [UIColor(rgb: 0x2A272E).color], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 1))
    )
}
