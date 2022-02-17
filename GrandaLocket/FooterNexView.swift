//
//  FooterNexView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 17.02.2022.
//

import SwiftUI

struct FooterView: View {

    @Binding var destination: AppDestination
    let nextDestination: AppDestination
    private let buttonHeight: CGFloat = 48
    private static var footerHeight: CGFloat {
        48 + 16 + 16 + (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! ?? 0.0
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            BlurView(style: .dark)
                .frame(maxWidth: .infinity)
            Button {
                ContactsInfo.instance.requestAccessIfNeeded()
                destination = nextDestination
            } label: {
                Text("NEXT")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: buttonHeight)
                    .background {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke()
                            .foregroundColor(Color(rgb: 0x92FFF8))
                    }
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
        }
        .frame(height: Self.footerHeight)
    }
}
