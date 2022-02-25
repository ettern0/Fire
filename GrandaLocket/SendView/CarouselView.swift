//
//  ContactList.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 16.02.2022.
//

import SwiftUI

struct CarouselView: View {
    @ObservedObject var viewModel: SendViewModel
    @State var maxScale: CGFloat = 1
    @Binding var selectedMode: SendSelectedMode
    let sizeOfstaticElement: CGFloat = 60
    let sizeOfScaledElement: CGFloat = 120
    let spacingHorizontal: CGFloat = 20

    var maxRatio: CGFloat {
        sizeOfScaledElement/sizeOfstaticElement
    }

    var yOffset: CGFloat {
        (sizeOfScaledElement - sizeOfstaticElement)/2
    }

    var xSpacing: CGFloat {
        (sizeOfScaledElement - sizeOfstaticElement)/2
    }

    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(viewModel.friends) { friend in
                        CarouselContactView(viewModel: viewModel, friend: friend)
                    }
            }
        }
            .padding(15)
    }
}

struct CarouselContactView: View {
    @ObservedObject var viewModel: SendViewModel
    var friend: SendViewModel.Friend

    var body: some View {
        ZStack {
            VStack(spacing: 4) {

                if friend.image != nil {
                    ImageAvatar(image: friend.image!, frame: CGSize(width: 100, height: 100))
                        .foregroundColor(.black.opacity(0.0001)) // https://stackoverflow.com/a/57157130
                        .overlay {
                            if friend.isSelected {
                                Circle()
                                    .foregroundColor(Palette.blackMiddle)
                                    .opacity(0.5)
                                Image("selected")
                            }
                        }
                } else {
                    TextAvatar(textForIcon: "",
                               frame: CGSize(width: 100, height: 100),
                               strokeColor: Palette.accent)
                        .background {
                            if friend.isSelected {
                                Image("selected")
                            }
                        }
                }
                Text(friend.firstName)
                    .frame(width: 60, height: 20)
                    .font(Typography.controlL)
                    .lineLimit(nil)
            }
        }
        .onTapGesture {
            if let index = viewModel.friends.firstIndex(of: friend) {
                viewModel.friends[index].isSelected = !viewModel.friends[index].isSelected
            }
        }
    }
}
