//
//  FooterNexView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 17.02.2022.
//

import SwiftUI

struct FooterNextView: View {
    @Binding var destination: AppDestination
    let nextDestination: AppDestination
    private static let buttonHeight: CGFloat = 48

    private static var footerHeight: CGFloat {
        Self.buttonHeight + 16 + 16 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            BlurView(style:.dark)
                .frame(maxWidth: .infinity)
            Button {
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

struct FooterSendView: View {

    @Binding var destination: AppDestination
    @Binding var snaphotImage: Image
    let nextDestination: AppDestination
    private let buttonHeight: CGFloat = 48
    private let spacingHStack: CGFloat = 24
    private let widthOfButtonSend: CGFloat = 115

    var footerOffset: CGFloat {
        -((spacingHStack + buttonHeight)/2)
    }

    var body: some View {
        VStack {
            Spacer()
            snaphotImage
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.width)
            CarouselView()
            HStack(spacing: spacingHStack) {
                Button {
                    destination = .main
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: buttonHeight, height: buttonHeight)
                            .foregroundColor(.white)
                            .opacity(0.20)
                        Image("bin")
                            .accentColor(.white)
                    }
                }
                Button {
                    destination = nextDestination
                } label: {
                    Text("SEND")
                        .frame(height: buttonHeight)
                }.buttonStyle(LargeCapsuleButtonStyle())
                    .frame(width: widthOfButtonSend, height: buttonHeight)
            }
            .offset(x: footerOffset)
            .padding(.vertical, 48)
        }
    }
}
