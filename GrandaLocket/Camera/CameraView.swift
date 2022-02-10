
import SwiftUI
import Combine
import AVFoundation
import Foundation

final class CameraModel: ObservableObject {
    let videoProvider: VideoProvider
    private let service = CameraService()
    private var subscriptions = Set<AnyCancellable>()

    @Published var photo: Photo!
    @Published var showAlertError = false
    @Published var isFlashOn = false
    @Published var willCapturePhoto = false
    var alertError: AlertError!
    var session: AVCaptureSession // удалить

    init() {
        let session = service.session
        self.session = session
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
    }
}

// MARK: Camera View

struct CameraPreview: View {
    @ObservedObject var videoProvider: VideoProvider

    var image: UIImage?

    init(videoProvider: VideoProvider) {
        self.videoProvider = videoProvider
    }

    var body: some View {
        if let image = videoProvider.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            EmptyView()
        }
    }
}

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
}

func imageFromSampleBuffer(
        sampleBuffer: CMSampleBuffer,
        videoOrientation: AVCaptureVideoOrientation) -> UIImage? {
        if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            let context = CIContext()
            var ciImage = CIImage(cvPixelBuffer: imageBuffer)

            // FIXME: - change to Switch
            if videoOrientation == .landscapeLeft {
                ciImage = ciImage.oriented(forExifOrientation: 3)
            } else if videoOrientation == .landscapeRight {
                ciImage = ciImage.oriented(forExifOrientation: 1)
            } else if videoOrientation == .portrait {
                ciImage = ciImage.oriented(forExifOrientation: 6)
            } else if videoOrientation == .portraitUpsideDown {
                ciImage = ciImage.oriented(forExifOrientation: 8)
            }

            if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return nil
    }
