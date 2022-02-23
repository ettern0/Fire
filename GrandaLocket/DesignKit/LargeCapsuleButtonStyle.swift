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
            .font(.system(size: 13).bold())
            .foregroundColor(.black.opacity(configuration.isPressed ? 0.7 : 1))
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background {
                Capsule()
                    .fill(.black.opacity(0.0001)) // https://stackoverflow.com/a/57157130
                    .overlay {
                        Capsule()
                            .foregroundColor(Palette.accent)
                            .opacity(configuration.isPressed ? 0.7 : 1.0)

                    }
            }
    }
}
