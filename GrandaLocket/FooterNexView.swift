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
    private static let buttonHeight: CGFloat = 48

    private static var footerHeight: CGFloat {
        Self.buttonHeight + 16 + 16 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0)
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
                    .frame(height: Self.buttonHeight)
            }.buttonStyle(LargeCapsuleButtonStyle())

            .padding(.top, 16)
            .padding(.horizontal, 16)
        }
        .frame(height: Self.footerHeight)
    }
}
