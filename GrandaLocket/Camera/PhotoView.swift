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
    @State var currentZoomFactor: CGFloat = 1.0
    @State var selectedMode: Modes = .photo
    @State var selected: Int = 0

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                cameraView(blurRadius: 8, position: .top)
                    .frame(width: proxy.size.width, height: (proxy.size.height - proxy.size.width) / 2)
                cameraView(position: .center)
                    .frame(width: proxy.size.width, height: proxy.size.width)
                ZStack {
                    cameraView(blurRadius: 8, position: .bottom)
                        .frame(width: proxy.size.width, height: (proxy.size.height - proxy.size.width) / 2)
                    buttonAreaView
                }
            }
        }
    }

    func cameraView(blurRadius: CGFloat = 0, position: ImagePosition) -> some View {
        CameraPreview(videoProvider: model.videoProvider, position: position)
            .blur(radius: blurRadius, opaque: true)
            .clipped()
    }

    var buttonAreaView: some View {
        VStack {
            Spacer()
            Text("\(selected)")
           // transitPicker()
            HorizontalPickerTestView(selected: $selected)
                .frame(maxHeight: 50)
                .clipped()
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
                    .opacity(0.20)
                Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .accentColor(model.isFlashOn ? .yellow : .white)
            }
        })
    }

    var captureButton: some View {
        Button(action: {
            model.capturePhoto()
        }, label: {
            ZStack {
                Circle()
                    .foregroundColor(Color(UIColor(hexString: "6E0DFF")))
                    .frame(width: 80, height: 90, alignment: .center)
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
}

struct PhotoView_Previews: PreviewProvider {
  static var previews: some View {
      PhotoView()
    }
}
