//
//  BlurView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 10.02.2022.
//

import Foundation
import UIKit
import SwiftUI

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        let effect = UIBlurEffect(style: style)
        uiView.effect = effect
    }
}
