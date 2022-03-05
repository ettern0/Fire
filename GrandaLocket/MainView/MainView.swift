//
//  MainView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 10.02.2022.
//

import SwiftUI
import UIKit
import KeyboardObserver

struct MainView: View {
    @StateObject var model = CameraModel()
    @State private var currentZoomFactor: CGFloat = 1.0
    @State private var selectedMode: LocketMode = .photo
    @State private var xDirection: GesturesDirection = .left
    @State private var yDirection: GesturesDirection = .top
    @State private var textStyle: TextLocketStyle = .violet
    @Binding var destination: AppDestination
    @Binding var snapshotImage: UIImage
    @State private var state = KeyboardState()
    @State private var screenshotMaker: ScreenshotMaker?
    @State private var text: String = ""
    @State private var isEditingText: Bool = false

    private var minXToChangeMode: CGFloat {
        UIScreen.main.bounds.width * 0.2
    }
    private var minYToChangeMode: CGFloat {
        UIScreen.main.bounds.height * 0.1
    }

    private func bottomHeight(containerSize: CGSize, keyboardHeight: CGFloat) -> CGFloat {
        if keyboardHeight.isZero || selectedMode == .photo {
            return (containerSize.height - containerSize.width) / 2
        } else {
            return keyboardHeight
        }
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                locketCreationContainer(position: .top)
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.height -
                          proxy.size.width -
                          bottomHeight(containerSize: proxy.size, keyboardHeight: state.height(in: proxy))
                    )
                locketCreationContainer(position: .center, isEditing: isEditingText)
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.width
                    )
                    .screenshotView { screenshotMaker in
                        self.screenshotMaker = screenshotMaker
                    }
                ZStack {
                    locketCreationContainer(position: .bottom)
                    buttonAreaView
                }
                .frame(
                    width: proxy.size.width,
                    height: bottomHeight(containerSize: proxy.size, keyboardHeight: state.height(in: proxy))
                )
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        changeModeWithDirection(xOld: value.startLocation.x, xNew: value.location.x,
                                                yOld: value.startLocation.y, yNew: value.location.y)
                    }
            )
        }
        .observingKeyboard($state)
    }

    var buttonAreaView: some View {
        VStack {
            Spacer()
            LocketModeControl(selectedMode: $selectedMode)
            HStack {
                flashButton
                captureButton
                flipCameraButton
            }
            transitButton
                .padding(.bottom)
                .padding(.bottom)
        }
    }

    var flashButton: some View {
        Button(action: {
            model.switchFlash()
        }, label: {
            ZStack {
                Circle()
                    .frame(width: 65, height: 65, alignment: .center)
                    .foregroundColor(.white)
                    .opacity(0.20)
                Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .accentColor(model.isFlashOn ? .white : .white)
            }
        })
    }

    var captureButton: some View {
        Button(action: {
            if let image = screenshotMaker?.screenshot() {
                snapshotImage = image
                destination = .send
            } else {
//                assertionFailure("Can not create snapshot")
            }
            destination = .send
        }, label: {
            ZStack {
                Circle()
                    .fill(Palette.accent)
                    .frame(width: 80, height: 90, alignment: .center)
                    .animation(.default, value: selectedMode)
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 65, height: 65, alignment: .center)
                Circle()
                    .stroke(Color.black.opacity(0.8), lineWidth: 2)
                    .frame(width: 65, height: 65, alignment: .center)
            }
        }).padding()
    }

    var flipCameraButton: some View {
        Button(action: {
            model.flipCamera()
        }, label: {
            ZStack {
                Circle()
                    .frame(width: 65, height: 65, alignment: .center)
                    .foregroundColor(.white)
                    .opacity(0.20)
                Image(systemName: "camera.rotate.fill")
                    .foregroundColor(.white)
            }
        })
    }

    var transitButton: some View {
        Button {
            destination = .feed
        } label: {
            Image("angle_down")
        }
        .padding(.top, -15)
    }
    func locketCreationContainer(position: ImagePosition, isEditing: Bool = false) -> some View {
        Group {
            switch selectedMode {
                case .photo:
                ZStack {
                    CameraPreview(videoProvider: model.videoProvider, position: position)
                        .blur(radius: blurRadius(for: position), opaque: true)
                        .clipped()
                }
                case .text:
                    switch position {
                        case .top:
                            ZStack {
                                TextViewBackground(style: textStyle, position: position)
                                TextLocketStylePicker(selectedStyle: $textStyle)
                            }
                        case .center:
                            ZStack {
                                TextViewBackground(style: textStyle, position: position)
                                HealthyPersonTextEditor(text: $text, isEditing: $isEditingText)
                            }
                        case .bottom:
                            TextViewBackground(style: textStyle, position: position)
                    }
            }
        }
        .animation(.default, value: selectedMode)
        .transition(self.selectedMode == .photo ? .slide : .backslide)
    }

    private func blurRadius(for position: ImagePosition) -> CGFloat {
        switch position {
            case .top:
                return 8
            case .center:
                return 0
            case .bottom:
                return 8
        }
    }

    private func changeModeWithDirection(xOld: CGFloat, xNew: CGFloat, yOld: CGFloat, yNew: CGFloat) {

        let difX = abs(xOld - xNew)
        let difY = abs(yOld - yNew)

        //change x direction
        if difX > difY {

            if xOld > xNew, difX > minXToChangeMode {
                xDirection = .right
            } else if xOld < xNew, difX > minXToChangeMode {
                xDirection = .left
            }

            withAnimation {
                if xDirection == .left, selectedMode == .text {
                    selectedMode = .photo
                } else if xDirection == .right, selectedMode == .photo {
                    selectedMode = .text
                }
            }

        } else {

            if yOld < yNew, difY > minYToChangeMode {
                yDirection = .top
                isEditingText = false
            } else if yOld > yNew, difY > minYToChangeMode {
                yDirection = .bottom

            }

            withAnimation {
                if yDirection == .bottom {
                    destination = .feed
                }
            }
        }
    }
}
