//
//  SmallCapsuleButtonStyle.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 17.02.2022.
//

import SwiftUI

struct SmallCapsuleButtonStyle: ButtonStyle {

    var active: Bool = true
    var capsuleFillColor: Color {
        return active ? Palette.accent: Palette.blackLight
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13).bold())
            .foregroundColor(Palette.blackHard.opacity(configuration.isPressed ? 0.7 : 1))
            .padding(.vertical, 6)
            .padding(.horizontal, 18)
            .background {
                Capsule()
                    .fill(capsuleFillColor)
            }
    }
}

struct SmallDeclineCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13).bold())
            .foregroundColor(.black.opacity(configuration.isPressed ? 0.7 : 1))
            .padding(.vertical, 6)
            .padding(.horizontal, 18)
            .background {
                Capsule()
                    .fill(Palette.whiteOpacity)
            }
    }
}
