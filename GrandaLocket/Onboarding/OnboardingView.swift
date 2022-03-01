//
//  OnboardingView.swift
//  GrandaLocket
//
//  Created by Аня on 21/02/22.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selection: Int = 0
    @Binding var destination: AppDestination

    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                content(
                    title: "Add the widget",
                    subtitle: "Long tap on the home screen to add\na widget and adjust it's size",
                    imageName: "Onboarding1"
                )
                .tag(0)
                content(
                    title: "Send your Fire",
                    subtitle: "Share messages and photos\nwith your friends using the widget",
                    imageName: "Onboarding2"
                ).tag(1)
                content(
                    title: "React this 🔥",
                    subtitle: "Put a reaction to the best messages,\nsee how many friends reacted to you",
                    imageName: "Onboarding3"
                ).tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        destination = .phoneNumberAuth
                    } label: {
                        Text(selection == 2 ? "Next" : "Skip")
                        .foregroundColor(.white)
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }

    private func content(title: String, subtitle: String, imageName: String) -> some View {
        VStack {
            Text(title)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .foregroundColor(.white)
                .font(Typography.headerL)
                .multilineTextAlignment(.center)
            Text(subtitle)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .foregroundColor(.white)
                .font(Typography.description)
                .multilineTextAlignment(.center)
                .opacity(0.8)
                .lineSpacing(4)
            PageControl(numberOfPages: 3, currentPage: $selection)
            Spacer()
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 0)
        }
    }
}


