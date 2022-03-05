//
//  FooterSendView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 21.02.2022.
//

import SwiftUI

private enum SendStatus {
    case inProgress, success
}

struct FooterSendView: View {
    @Binding var destination: AppDestination
    @Binding var selectedMode: SendSelectedMode
    let nextDestination: AppDestination
    let snapshotImage: UIImage
    @ObservedObject var viewModel: SendViewModel
    private let buttonHeight: CGFloat = 48
    private let spacingHStack: CGFloat = 24
    private let widthOfButtonSend: CGFloat = 115
    @State private var sendStatus: SendStatus?
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
                    sendStatus = .inProgress
                    imagesService.send(
                        image: snapshotImage,
                        to: viewModel.friends.filter(\.isSelected).compactMap(\.id)
                    ) { status in
                        sendStatus = .success
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                            destination = .main
                        }
                    }
                } label: {
                    if let progress = sendStatus {
                        switch progress {
                        case .inProgress:
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        case .success:
                            LottieView(name: "checkmark")
                        }
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
