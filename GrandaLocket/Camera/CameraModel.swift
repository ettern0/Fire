//
//  CameraModel.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 10.02.2022.
//

import SwiftUI
import Combine
import Foundation
import AVFoundation

final class CameraModel: ObservableObject {
    let videoProvider: VideoProvider
    private let service = CameraService()
    private var subscriptions = Set<AnyCancellable>()

    @Published var photo: Photo!
    @Published var showAlertError = false
    @Published var isFlashOn = false
    @Published var willCapturePhoto = false
    var alertError: AlertError!

    init() {
        let session = service.session
        self.videoProvider = .init(session: session)

        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.photo = pic
        }
        .store(in: &self.subscriptions)

        service.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)

        service.$flashMode.sink { [weak self] (mode) in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)

        service.$willCapturePhoto.sink { [weak self] (val) in
            self?.willCapturePhoto = val
        }
        .store(in: &self.subscriptions)

        self.configure()
    }

    func configure() {
        service.checkForPermissions()
        service.configure()
    }

    func capturePhoto() {
        service.capturePhoto()
    }

    func flipCamera() {
        service.changeCamera()
    }

    func zoom(with factor: CGFloat) {
        service.set(zoom: factor)
    }

    func switchFlash() {
        service.flashMode = service.flashMode == .on ? .off : .on
        AVCaptureDevice.toggleTorch(on: service.flashMode == .on)
    }
}

extension AVCaptureDevice {
    static func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}
