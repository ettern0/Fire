
import SwiftUI
import Combine
import AVFoundation

final class CameraModel: ObservableObject {

    private let service = CameraService()
    private var subscriptions = Set<AnyCancellable>()

    @Published var photo: Photo!
    @Published var showAlertError = false
    @Published var isFlashOn = false
    @Published var willCapturePhoto = false
    var alertError: AlertError!
    var session: AVCaptureSession

    init() {
        self.session = service.session
        
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

struct PhotoView: View {

    @StateObject var model = CameraModel()
    @State var currentZoomFactor: CGFloat = 1.0
    @State var selectedMode: Modes = .photo

    var body: some View {
        ZStack {
            CameraView
            blurView
            buttonAreaView
        }
    }

    var CameraView: some View {
        CameraPreview(session: model.session)
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height, alignment: .center)
            .onAppear {
                model.configure()
            }
            .alert(isPresented: $model.showAlertError, content: {
                Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                    model.alertError.primaryAction?()
                }))
            })
            .overlay(
                withAnimation {
                    Group {
                        if model.willCapturePhoto {
                            Color.black
                        }
                    }
                }
            )
    }

    var blurView: some View {
        VStack {
            VStack {
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height/5)
                    .blur(radius: 1)
                    .opacity(0.4)

            }
            Spacer()
            VStack {
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height/3.5)
                    .blur(radius: 1)
                    .opacity(0.4)
            }
        }
    }

    var buttonAreaView: some View {
        VStack {
            Spacer()
            transitPicker
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

    var transitPicker: some View {

//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack {
//                ForEach(Modes.allCases) { item in
//                    Text(item.rawValue)
//                }
//            }
//        }
        Picker("Modes", selection: $selectedMode) {
            ForEach(Modes.allCases) { mode in
                Text(mode.rawValue)
            }
        }
        .pickerStyle(.segmented)


//        Picker(selection: $selectedMode, label: Text("Modes")) {
//            ForEach(Modes.allCases) { item in
//                Text(item.rawValue)
//            }
//        }
//        .labelsHidden()
//        .rotationEffect(Angle(degrees: -90))
//        .frame(maxHeight: 100)
//        .clipped()

//        ScrollView(.horizontal, showsIndicators: false) {
//
//            ScrollViewReader { scrollView in
//
//                HStack(spacing: 35) {
//
//                    ForEach(Modes.allCases) { item in
//                        if item.id == currentIndex {
//                            ZStack() {
//                                Text(item.title)
//                                    .bold()
//                                    .layoutPriority(1)
//                                VStack() {
//                                    Rectangle().frame(height: 2)
//                                        .padding(.top, 20)
//                                }
//                                .matchedGeometryEffect(id: "animation", in: ns)
//                            }
//                        } else {
//                            Text(item.title)
//                                .onTapGesture {
//                                    withAnimation {
//                                        currentIndex = item.id
//                                        selectedIndex = currentIndex
//                                        scrollView.scrollTo(item)
//                                    }
//                                }
//                        }
//                    }
//                }
//            }
//        }
    }

    var transitButton: some View {
        Button {

        } label: {
            Image("angle_down")
        }
        .padding(.top, -15)
    }
}

// MARK: Camera View
struct CameraPreview: UIViewRepresentable {

    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
             AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }

    let session: AVCaptureSession

    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: VideoPreviewView, context: Context) {

    }
}

// MARK: Preview
struct ContentView_Camera: PreviewProvider {
    static var previews: some View {
        PhotoView().preferredColorScheme(.dark)
    }
}
