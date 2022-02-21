//
//  HealthyPersonTextEditor.swift
//  GrandaLocket
//
//  Created by Alexey Salangin on 15.02.2022.
//

import UIKit
import SwiftUI

struct HealthyPersonTextEditor: UIViewRepresentable {
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 150)
        view.delegate = context.coordinator
        view.textColor = .white
        view.backgroundColor = .clear
        view.isScrollEnabled = false

        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {

    }

    typealias UIViewType = UITextView


    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        func textViewDidChange(_ textView: UITextView) {
            textView.fitText(maxLines: 5)
        }
    }
}

enum TextSizingOption: Equatable {
    case preferredLineCount(UInt)
    case fillContainer

    static func == (lhs: TextSizingOption, rhs: TextSizingOption) -> Bool {
        switch (lhs, rhs) {
        case (let .preferredLineCount(lines1), let .preferredLineCount(lines2)):
            return lines1 == lines2
        case (.fillContainer,.fillContainer):
            return true
        default:
            return false
        }
    }
}


extension UITextView {

    /**
     Autosizes `font` to the largest value where the text fills the `maxLines` provided.

     Depending on the bounds of the view, the actual number of lines occupied by the text may
     be less than the preferred amount provided.
     */
    func fitText(maxLines: UInt) {
        guard let text = text else { return }
        let font = self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        self.font = UIFont.fontFittingText(text, in: textBoundingBox.size, fontDescriptor: font.fontDescriptor, option: .preferredLineCount(maxLines))
    }

    /**
     Autosizes `font` to the largest value where the text can still be contained in the view's bounds.
     */
    func fitTextToBounds() {
        guard let text = text else { return }
        let font = self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        self.font = UIFont.fontFittingText(text, in: textBoundingBox.size, fontDescriptor: font.fontDescriptor, option: .fillContainer)
    }

    private var textBoundingBox: CGRect {
        var textInsets: UIEdgeInsets = textContainerInset
        textInsets.left += textContainer.lineFragmentPadding
        textInsets.right += textContainer.lineFragmentPadding
        return bounds.inset(by: textInsets)
    }
}

extension UIFont {

    /**
     Provides the largest font which fits the text in the given bounds.
     */
    static func fontFittingText(_ text: String, in bounds: CGSize, fontDescriptor: UIFontDescriptor, option: TextSizingOption) -> UIFont? {
        let properBounds = CGRect(origin: .zero, size: bounds)
        let largestFontSize = Int(bounds.height)
        let constrainingBounds = CGSize(width: properBounds.width, height: CGFloat.infinity)

        let bestFittingFontSize: Int? = (1...largestFontSize).reversed().first(where: { fontSize in
            let font = UIFont(descriptor: fontDescriptor, size: CGFloat(fontSize))
            let currentFrame = text.boundingRect(with: constrainingBounds, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)

            if properBounds.contains(currentFrame) {
                let currentFrameLineCount = Int(ceil(currentFrame.height / font.lineHeight))
                if case .preferredLineCount(let lineCount) = option, currentFrameLineCount > max(lineCount, 1) {
                    return false
                }
                return true
            }

            return false
        })

        guard let fontSize = bestFittingFontSize else { return nil }
        return UIFont(descriptor: fontDescriptor, size: CGFloat(fontSize))
    }
}
