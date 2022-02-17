//
//  LargeCapsuleButtonStyle.swift
//  GrandaLocket
//
//  Created by Alexey Salangin on 17.02.2022.
//

import SwiftUI

struct LargeCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.custom("ALSHauss-Bold", size: 13))
            .foregroundColor(.white.opacity(configuration.isPressed ? 0.7 : 1))
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background {
                Capsule()
                    .fill(.black.opacity(0.0001)) // https://stackoverflow.com/a/57157130
                    .overlay {
                        Capsule()
                            .stroke(lineWidth: 4)
                            .foregroundColor(Color(rgb: 0x92FFF8).opacity(configuration.isPressed ? 0.7 : 1))

                    }
            }
    }
}
