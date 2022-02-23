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
    private let service = DownloadImageService()
    private var minYToChangeMode: CGFloat {
        UIScreen.main.bounds.height * 0.1
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                MyFeedView()
                MyFriendsFeedView()
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
        }.onAppear {
            // govnokod
            service.download() { value in

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
    @ObservedObject private var viewModel = MyFriendsFeedViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text("My Friends")
                .font(Typography.headerM)
                .padding(.bottom, 20)
            ForEach(viewModel.friends, id: \.self) { friend in
                Text(friend.name)
                Text(friend.phone)
                if friend.lockets.isEmpty {
                    Text("Душнила-друг ничего тебе не послал")
                } else {
                    Text("Посты любимого друга")
                }
            }
        }
    }
}

private struct MyFeedView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("My Fire")
                .font(Typography.headerM)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(1...10, id: \.self) {_ in 
                    Image("example")
                        .resizable()
                        .frame(width: 100, height: 100)
                    }
                }
            }
        }
    }
}
