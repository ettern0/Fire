//
//  SendView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 21.02.2022.
//

import SwiftUI
import Combine

struct SendView: View {

    @Binding var destination: AppDestination
    @Binding var snapshotImage: UIImage
    @State var selectedMode: SendSelectedMode = .allFriends
    @State private var menuIsOpen: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image(uiImage: snapshotImage)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.width)
                Spacer()
                FooterSendView(
                    destination: $destination,
                    selectedMode: $selectedMode,
                    nextDestination: .main,
                    snapshotImage: snapshotImage
                )
            }
            .navigationTitle(selectedMode.rawValue)
            .font(Typography.headerM)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            selectedMode = .allFriends
                        } label: {
                            HStack {
                                Text(SendSelectedMode.allFriends.rawValue)
                                Image("multiplyUsers")
                            }
                        }
                        Button {
                            selectedMode = .selectFriends
                        } label: {
                            HStack {
                                Text(SendSelectedMode.selectFriends.rawValue)
                                Text(SendSelectedMode.allFriends.rawValue)
                                Image("singleUser")
                            }
                        }
                    } label: {
                        Image(menuIsOpen ? "angle_up" : "angle_down")
                    }
                }
            }
        }
    }
}
