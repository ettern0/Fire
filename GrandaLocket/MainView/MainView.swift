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
                locketCreationContainer(position: .center)
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.width
                    )
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
                        changexDirection(value.startLocation.x, value.location.x)
                        changeyDirection(value.startLocation.y, value.location.y)
                        changeModeWithxDirection()
                        changeModeWithyDirection()
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
            snapshotImage = locketCreationContainer(position: .center).snapshot()
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

    @State var text: String = ""
    @State var isEditing: Bool = false

    func locketCreationContainer(position: ImagePosition) -> some View {
        Group {
            switch selectedMode {
                case .photo:
                    CameraPreview(videoProvider: model.videoProvider, position: position)
                        .blur(radius: blurRadius(for: position), opaque: true)
                        .clipped()
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
                                HealthyPersonTextEditor(text: $text, isEditing: $isEditing)
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

    private func changexDirection(_ xOld: CGFloat, _ xNew: CGFloat) {
        let dif = abs(xOld - xNew)
        if xOld > xNew, dif > minXToChangeMode {
            xDirection = .right
        } else if xOld < xNew, dif > minXToChangeMode {
            xDirection = .left
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

    private func changeModeWithxDirection() {
        withAnimation {
            if xDirection == .left, selectedMode == .text {
                selectedMode = .photo
            } else if xDirection == .right, selectedMode == .photo {
                selectedMode = .text
            }
        }
    }

    private func changeModeWithyDirection() {
        withAnimation {
            if yDirection == .bottom {
                destination = .feed
            }
        }
    }

}
