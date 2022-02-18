//
//  SmallCapsuleButtonStyle.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 17.02.2022.
//

import SwiftUI

struct SmallCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Typography.controlM)
            .foregroundColor(.black.opacity(configuration.isPressed ? 0.7 : 1))
            .padding(.vertical, 4)
            .padding(.horizontal, 16)
            .background {
                Capsule()
                    .fill(Palette.accent)
            }
    }
}
