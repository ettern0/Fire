//
//  PhotoView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 10.02.2022.
//

import SwiftUI
import UIKit

struct PhotoView: View {

    @StateObject var model = CameraModel()
    @State private var currentZoomFactor: CGFloat = 1.0
    @State private var selectedMode: LocketMode = .photo
    @State private var selected: Int = 0
    @State private var xDirection: GesturesDirection = .left
    @State private var yDirection: GesturesDirection = .top

    private var minXToChangeMode: CGFloat {
        UIScreen.main.bounds.width * 0.2
    }
    private var minYToChangeMode: CGFloat {
        UIScreen.main.bounds.height * 0.1
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                cameraView(blurRadius: 8, position: .top)
                    .frame(width: proxy.size.width, height: (proxy.size.height - proxy.size.width) / 2)
                cameraView(position: .center)
                    .frame(width: proxy.size.width, height: proxy.size.width)
                ZStack {
                    cameraView(blurRadius: 8, position: .bottom)
                    buttonAreaView
                }.frame(width: proxy.size.width, height: (proxy.size.height - proxy.size.width) / 2)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        changexDirection(value.startLocation.x, value.location.x)
                        changeyDirection(value.startLocation.y, value.location.y)
                    }
                    .onEnded { _ in
                        changeModeWithxDirection()
                    }
            )
        }
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
            model.capturePhoto()
        }, label: {
            ZStack {
                Circle()
                    .foregroundColor(selectedMode.tintColor)
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

        } label: {
            Image("angle_down")
        }
        .padding(.top, -15)
    }

    func cameraView(blurRadius: CGFloat = 0, position: ImagePosition) -> some View {
        CameraPreview(videoProvider: model.videoProvider, position: position)
            .blur(radius: blurRadius, opaque: true)
            .clipped()
    }

    func changeModeWithxDirection() {
        if xDirection == .left, selectedMode == .text {
            selectedMode.changeMode()
        } else if xDirection == .right, selectedMode == .photo {
            selectedMode.changeMode()
        }
    }

    func changexDirection(_ xOld: CGFloat, _ xNew: CGFloat) {
        let dif = abs(xOld - xNew)
        if xOld > xNew, dif > minXToChangeMode {
            xDirection = .right
        } else if xOld < xNew, dif > minXToChangeMode {
                xDirection = .left
            }
        }

    func changeyDirection(_ yOld: CGFloat, _ yNew: CGFloat) {
        let dif = abs(yOld - yNew)
        if yOld > yNew, dif > minYToChangeMode {
            yDirection = .top
        } else if yOld < yNew, dif > minYToChangeMode {
            yDirection = .bottom
            }
        }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView()
    }
}
