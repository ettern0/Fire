//
//  VideoProvider.swift
//  GrandaLocket
//
//  Created by Alexey Salangin on 10.02.2022.
//

import UIKit
import AVFoundation
import Combine

final class VideoProvider: NSObject, ObservableObject {
    @Published var image: UIImage?

    private let session: AVCaptureSession

    init(session: AVCaptureSession) {
        self.session = session
        super.init()
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoProvider"))
        session.addOutput(output)
    }
}

extension VideoProvider: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        _ = CIImage(cvPixelBuffer: imageBuffer)

        let image = imageFromSampleBuffer(sampleBuffer: sampleBuffer, videoOrientation: .portrait)!
        DispatchQueue.main.async {
            self.image = image
        }
    }

    private func convert(ciImage:CIImage) -> UIImage {
        let context: CIContext = CIContext.init(options: nil)
        let cgImage: CGImage = context.createCGImage(ciImage, from: ciImage.extent)!
        let image: UIImage = UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .left)
        return image
    }

    private func imageFromSampleBuffer(
        sampleBuffer: CMSampleBuffer,
        videoOrientation: AVCaptureVideoOrientation
    ) -> UIImage? {
        if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            let context = CIContext()
            var ciImage = CIImage(cvPixelBuffer: imageBuffer)

            switch videoOrientation {
                case .portrait:
                    ciImage = ciImage.oriented(forExifOrientation: 6)
                case .portraitUpsideDown:
                    ciImage = ciImage.oriented(forExifOrientation: 8)
                case .landscapeRight:
                    ciImage = ciImage.oriented(forExifOrientation: 1)
                case .landscapeLeft:
                    ciImage = ciImage.oriented(forExifOrientation: 3)
                @unknown default:
                    assertionFailure()
                    break
            }

            if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return nil
    }
}
