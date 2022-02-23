//
//  ScreenshotMaker.swift
//  GrandaLocket
//
//  Created by Alexey Salangin on 24.02.2022.
//

import UIKit
import SwiftUI

typealias ScreenshotMakerClosure = (ScreenshotMaker) -> Void

final class ScreenshotMaker: UIView {
    func screenshot() -> UIImage? {
        guard let containerView = self.superview?.superview,
              let containerSuperview = containerView.superview
        else { return nil }
        let renderer = UIGraphicsImageRenderer(bounds: containerView.frame)
        return renderer.image { context in
            containerSuperview.layer.render(in: context.cgContext)
        }
    }
}

extension View {
    func screenshotView(_ closure: @escaping ScreenshotMakerClosure) -> some View {
        let screenshotView = ScreenshotMakerView(closure)
        return overlay(screenshotView.allowsHitTesting(false))
    }
}

private struct ScreenshotMakerView: UIViewRepresentable {
    private let closure: ScreenshotMakerClosure

    init(_ closure: @escaping ScreenshotMakerClosure) {
        self.closure = closure
    }

    func makeUIView(context: Context) -> ScreenshotMaker {
        let view = ScreenshotMaker(frame: CGRect.zero)
        return view
    }

    func updateUIView(_ uiView: ScreenshotMaker, context: Context) {
        DispatchQueue.main.async {
            closure(uiView)
        }
    }
}
