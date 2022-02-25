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
    @ObservedObject var viewModel: SendViewModel
    private let buttonHeight: CGFloat = 48
    private let spacingHStack: CGFloat = 24
    private let widthOfButtonSend: CGFloat = 115
    @State var isLoading: Bool = false
    @State var selectedIDs: [String] = []
    private let imagesService = UserImagesService()

    var footerOffset: CGFloat {
        -((spacingHStack + buttonHeight)/2)
    }

    var body: some View {
        VStack(spacing: 50) {
            CarouselView(viewModel: viewModel, selectedMode: $selectedMode)
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
                    isLoading = true
                    imagesService.send(
                        image: snapshotImage,
                        to: viewModel.friends.filter(\.isSelected).compactMap(\.id)
                    ) { status in
                        isLoading = false
                        destination = .main
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    } else {
                        Text("SEND")
                    }
                }.buttonStyle(LargeCapsuleButtonStyle())
                    .frame(width: widthOfButtonSend, height: buttonHeight)
            }
            .offset(x: footerOffset)
        }
    }
}
