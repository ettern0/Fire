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
    let sizeOfScaledElement: CGFloat = 100
    let spacingHorizontal: CGFloat = 20

    var maxRatio: CGFloat {
        sizeOfScaledElement/sizeOfstaticElement
    }

    var body: some View {
//        GeometryReader { mainFrame in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
//                    ForEach(filtredContacts) { contact in
//                        GeometryReader { geo in
//                            CarouselContactView(selectedMode: selectedMode, contact: contact)
//                                .scaleEffect(
//                                    calcScale(mainFrame: mainFrame.frame(in: .global).maxX,
//                                              minX: geo.frame(in: .global).minX))
//                        }
//                        .frame(width: sizeOfScaledElement + spacingHorizontal)
//                    }
//                }
//                .position(x: 0, y: mainFrame.size.height)
                    ForEach(viewModel.friends) { friend in
                        CarouselContactView(viewModel: viewModel, friend: friend)
                    }
            }
        }.frame(height: sizeOfScaledElement * 2)
    }

    private func calcScale(mainFrame: CGFloat, minX: CGFloat) -> CGFloat {
        let scale = minX / mainFrame
        var decreesRatio = abs(2 - (abs(0.5 - scale) * 2))
        if decreesRatio > maxRatio {
            decreesRatio = maxRatio
        } else if decreesRatio < 1 {
            decreesRatio = 1
        }
        return decreesRatio
    }
}

struct CarouselContactView: View {
    @ObservedObject var viewModel: SendViewModel
    var friend: SendViewModel.Friend

    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                Circle()
                    .foregroundColor(.black.opacity(0.0001)) // https://stackoverflow.com/a/57157130
                    .frame(width: 100, height: 100)
                    .background {
                        Circle()
                            .stroke()
                            .foregroundColor(Palette.accent)
                    }
                    .background {
                        if friend.isSelected {
                            Image("selected")
                        }
                    }
                Text(friend.name)
                    .frame(width: 60, height: 20)
                    .font(Typography.descriptionS)
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
