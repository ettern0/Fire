//
//  TextLocketStylePicker.swift
//  GrandaLocket
//
//  Created by Alexey Salangin on 14.02.2022.
//

import SwiftUI

struct TextLocketStylePicker: View {
    @Binding var selectedStyle: TextLocketStyle

    var body: some View {
        HStack(spacing: 21) {
            ForEach(TextLocketStyle.allCases, id: \.id) { style in
                Button {
                    selectedStyle = style
                } label: {
                    style.centerGradient
                        .clipShape(Circle())
                        .frame(width: 21, height: 21)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
            }
        }
    }
}
