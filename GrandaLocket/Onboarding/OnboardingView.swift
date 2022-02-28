//
//  OnboardingView.swift
//  GrandaLocket
//
//  Created by Аня on 21/02/22.
//

import SwiftUI

struct OnboardingView: View {

        var body: some View {
            TabView {
                VStack {
                    Text("Add the widget")
                    .padding(.horizontal, 91)
                    .padding(.top, 101)
                    .padding(.bottom, 12)
                    .foregroundColor(.white)
                    .font(Typography.headerL)
                    .multilineTextAlignment(.center)
                    Text("Long tap on the home screen to add a widget and adjust it's size")
                    .padding(.horizontal, 63)
                    .padding(.bottom, 40)
                    .foregroundColor(.white)
                    .font(Typography.description)
                    .multilineTextAlignment(.center)
                    .opacity(0.8)
                    .lineSpacing(4)
                    Spacer()
                    Image("phoneMockup")
                    .padding(.bottom, 0)
                }
                VStack {
                    Text("Send your Fire")
                    .padding(.horizontal, 91)
                    .padding(.top, 101)
                    .padding(.bottom, 12)
                    .foregroundColor(.white)
                    .font(Typography.headerL)
                    .multilineTextAlignment(.center)
                    Text("Share messages and photos with your friends using the widget")
                    .padding(.horizontal, 63)
                    .padding(.bottom, 40)
                    .foregroundColor(.white)
                    .font(Typography.description)
                    .multilineTextAlignment(.center)
                    .opacity(0.8)
                    .lineSpacing(4)
                    Spacer()
                    Image("phoneMockup")
                    .padding(.bottom, 0)
                }
                VStack {
                Text("React this 🔥")
                    .padding(.horizontal, 91)
                    .padding(.top, 101)
                    .padding(.bottom, 12)
                    .foregroundColor(.white)
                    .font(Typography.headerL)
                    .multilineTextAlignment(.center)
                    Text("Put a reaction to the best messages, see how many friends reacted to you")
                        .padding(.horizontal, 63)
                        .padding(.bottom, 40)
                        .foregroundColor(.white)
                        .font(Typography.description)
                        .multilineTextAlignment(.center)
                        .opacity(0.8)
                        .lineSpacing(4)
                    Spacer()
                    Image("phoneMockup")
                    .padding(.bottom, 0)
                }
            }
            .tabViewStyle(.page)
            
//        label: {
//            HStack {
//                if inProgress {
//                    ProgressView()
//                        .scaleEffect(1.5, anchor: .center)
//                        .foregroundColor(.white)
//                } else {
//                    Text("Next")
//                        .foregroundColor(.white)
//                        .font(Typography.controlL)
//                }
//            }
        }
    }

//                FooterView(destination: $destination, nextDestination: .contacts)
//            .frame(maxWidth: .infinity)
//            .background(Palette.blackHard)



