//
//  FeedView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 22.02.2022.
//

import SwiftUI

struct FeedView: View {

    @Binding var destination: AppDestination
    @State private var yDirection: GesturesDirection = .bottom
    @ObservedObject var viewModel = FeedViewModel()
    private var minYToChangeMode: CGFloat {
        UIScreen.main.bounds.height * 0.1
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 40) {
                MyFeedView(viewModel: viewModel)
                MyFriendsFeedView(viewModel: viewModel)
                Spacer()
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        changeyDirection(value.startLocation.y, value.location.y)
                        changeModeWithyDirection()
                    }
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button {
                        destination = .main
                    } label: {
                        VStack {
                            Image("angle_up")
                                .opacity(0.8)
                            Text("Camera")
                                .font(Typography.controlL)
                                .foregroundColor(.white)
                                .opacity(0.8)
                        }
                    }
                }
            }
        }
    }

    private func changeyDirection(_ yOld: CGFloat, _ yNew: CGFloat) {
        let dif = abs(yOld - yNew)
        if yOld < yNew, dif > minYToChangeMode {
            yDirection = .top
        } else if yOld > yNew, dif > minYToChangeMode {
            yDirection = .bottom
        }
    }

    private func changeModeWithyDirection() {
        withAnimation {
            if yDirection == .top {
                destination = .main
            }
        }
    }
}

private struct MyFriendsFeedView: View {
    @ObservedObject var viewModel: FeedViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("My Friends")
                .font(Typography.headerM)
                .padding(.bottom, 20)
            ForEach(viewModel.friends, id: \.self) { friend in
                if friend.url.count > 0 {
                    Text(friend.name)
                        .font(Typography.headerS)
                        .padding(.bottom, 20)
                    UserPhotosView(urls: friend.url)
                }
            }
        }
    }
}

private struct MyFeedView: View {
    @ObservedObject var viewModel: FeedViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("My Fire")
                .font(Typography.headerM)
                .padding(.bottom, 20)
            UserPhotosView(urls: viewModel.myPhotos)
        }
    }
}

private struct UserPhotosView: View {
    let urls: Array<URL>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(urls, id: \.self) { url in
                    AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .background(.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
    }
}
