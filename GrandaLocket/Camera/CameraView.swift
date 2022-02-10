
import SwiftUI
import Combine
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
    }
}

// MARK: Camera View

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
            EmptyView()
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

extension UIImage {
    var croppedToDeviceScreen: UIImage? {
        let screenAspectRatio = UIScreen.main.bounds.width / UIScreen.main.bounds.height
        let width = screenAspectRatio * size.height
        let rect = CGRect(
            x: (size.width - width) / 2,
            y: 0,
            width: width,
            height: size.height
        )
        guard let cgImage = cgImage,
              let image = cgImage.cropping(to: rect)
        else { return nil }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }

    var topThird: UIImage? {
        let rect = CGRect(
            origin: .zero,
            size: .init(width: size.width, height: (size.height - size.width) / 2)
        )
        guard let cgImage = cgImage,
              let image = cgImage.cropping(to: rect)
        else { return nil }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }

    var centerThird: UIImage? {
        let rect = CGRect(
            origin: .init(x: 0, y: (size.height - size.width) / 2),
            size: .init(width: size.width, height: size.width)
        )
        guard let cgImage = cgImage,
              let image = cgImage.cropping(to: rect)
        else { return nil }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }
    
    var bottomThird: UIImage? {
        let rect = CGRect(
            origin: .init(x: 0,  y: (size.height - size.width) / 2 + size.width),
            size: .init(width: size.width, height: (size.height - size.width) / 2)
        )
        guard let cgImage = cgImage,
              let image = cgImage.cropping(to: rect)
        else { return nil }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }
}
