//
//  CameraView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 10.02.2022.
//

import SwiftUI
import Combine
import Foundation

enum ImagePosition {
    case top
    case center
    case bottom
}

struct CameraPreview: View {
    @ObservedObject var videoProvider: VideoProvider
    private let position: ImagePosition

    var image: UIImage?

    init(videoProvider: VideoProvider, position: ImagePosition) {
        self.videoProvider = videoProvider
        self.position = position
    }

    var body: some View {
        if let image = videoProvider.image.flatMap(self.croppedImage(image:)) {
            Image(uiImage: image)
                .resizable()
        } else {
            Palette.blackHard
        }
    }

    private func croppedImage(image: UIImage) -> UIImage? {
        guard let image = image.croppedToDeviceScreen else { return nil }
        switch position {
            case .top:
                return image.topThird
            case .center:
                return image.centerThird
            case .bottom:
                return image.bottomThird
        }
    }
}
