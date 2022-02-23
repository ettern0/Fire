//
//  FooterSendView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 21.02.2022.
//

import SwiftUI

struct FooterSendView: View {

    @Binding var destination: AppDestination
    @Binding var selectedMode: SendSelectedMode
    let nextDestination: AppDestination
    let snapshotImage: UIImage
    private let buttonHeight: CGFloat = 48
    private let spacingHStack: CGFloat = 24
    private let widthOfButtonSend: CGFloat = 115

    var footerOffset: CGFloat {
        -((spacingHStack + buttonHeight)/2)
    }

    var body: some View {
        VStack {
            CarouselView(selectedMode: $selectedMode)
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
                    StorageManager().persistImageToStorage(image: snapshotImage) { url in
                       // UserService().saveImageRef(from:, to: )
                            print(url )
                        destination = .main
                    }
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
