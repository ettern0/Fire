//
//  SendView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 21.02.2022.
//

import SwiftUI


struct SendView: View {

    @Binding var destination: AppDestination
    @Binding var snaphotImage: Image
    @State var selectedMode: SendSelectedMode = .allFriends
    @State private var menuIsOpen: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                snaphotImage
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.width)
                FooterSendView(destination: $destination,
                               selectedMode: $selectedMode,
                               nextDestination: .main)
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
