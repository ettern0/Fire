//
//  TextViewBackground.swift
//  GrandaLocket
//
//  Created by Alexey Salangin on 14.02.2022.
//

import SwiftUI

struct TextViewBackground: View {
    let style: TextLocketStyle
    let position: ImagePosition

    var body: some View {
        switch position {
            case .top:
                self.style.topGradient
            case .center:
                self.style.centerGradient
            case .bottom:
                self.style.bottomGradient
        }
    }
}
