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
        HStack(spacing: 24) {
            ForEach(TextLocketStyle.allCases, id: \.id) { style in
                Button {
                    selectedStyle = style
                } label: {
                    style.centerGradient
                        .clipShape(Circle())
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .frame(alignment: .leading)

                }
            }
        }
    }
}
