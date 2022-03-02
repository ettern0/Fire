//
//  HealthyPersonTextEditor.swift
//  GrandaLocket
//
//  Created by Alexey Salangin on 15.02.2022.
//

import UIKit
import SwiftUI

private final class VerticallyCenteredTextView: UITextView {
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
}

struct HealthyPersonTextEditor: View {
    @Binding private var text: String
    @Binding private var isEditing: Bool

    private let placeholder: String?
    private let textHorizontalPadding: CGFloat
    private let textVerticalPadding: CGFloat
    private let placeholderAlignment: Alignment
    private let placeholderHorizontalPadding: CGFloat
    private let placeholderVerticalPadding: CGFloat
    private let textColor: UIColor
    private let placeholderColor: Color
    private let backgroundColor: UIColor
    private let returnType: UIReturnKeyType
    private let keyboardDismissMode: UIScrollView.KeyboardDismissMode
    private let isEditable: Bool
    private let isSelectable: Bool
    private let isScrollingEnabled: Bool
    private let placeholderFont: Font

    init(
        text: Binding<String>,
        isEditing: Binding<Bool>,
        placeholder: String? = nil,
        textHorizontalPadding: CGFloat = 0,
        textVerticalPadding: CGFloat = 7,
        placeholderAlignment: Alignment = .topLeading,
        placeholderHorizontalPadding: CGFloat = 4.5,
        placeholderVerticalPadding: CGFloat = 7,
        textColor: UIColor = .label,
        placeholderColor: Color = .init(.placeholderText),
        backgroundColor: UIColor = .clear,
        returnType: UIReturnKeyType = .default,
        keyboardDismissMode: UIScrollView.KeyboardDismissMode = .none,
        isEditable: Bool = true,
        isSelectable: Bool = true,
        isScrollingEnabled: Bool = true
    ) {
        _text = text
        _isEditing = isEditing

        self.placeholderFont = Font.system(size: 50)
        self.placeholder = placeholder
        self.textHorizontalPadding = textHorizontalPadding
        self.textVerticalPadding = textVerticalPadding
        self.placeholderAlignment = placeholderAlignment
        self.placeholderHorizontalPadding = placeholderHorizontalPadding
        self.placeholderVerticalPadding = placeholderVerticalPadding
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.backgroundColor = backgroundColor
        self.returnType = returnType
        self.keyboardDismissMode = keyboardDismissMode
        self.isEditable = isEditable
        self.isSelectable = isSelectable
        self.isScrollingEnabled = isScrollingEnabled
    }

    private var _placeholder: String? {
        text.isEmpty ? placeholder : nil
    }

    private func representable(isEditing: Binding<Bool>) -> TextViewRepresentable {
        .init(
            text: $text,
            isEditing: isEditing,
            textHorizontalPadding: textHorizontalPadding,
            textVerticalPadding: textVerticalPadding,
            textColor: textColor,
            backgroundColor: backgroundColor,
            returnType: returnType,
            keyboardDismissMode: keyboardDismissMode,
            isEditable: isEditable,
            isSelectable: isSelectable,
            isScrollingEnabled: isScrollingEnabled
        )
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.representable(isEditing: $isEditing)
                self._placeholder.map { placeholder in
                    Text(placeholder)
                        .font(.init(self.placeholderFont))
                        .foregroundColor(self.placeholderColor)
                        .padding(.horizontal, self.placeholderHorizontalPadding)
                        .padding(.vertical, self.placeholderVerticalPadding)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height,
                            alignment: self.placeholderAlignment
                        )
                        .onTapGesture {
                            self.isEditing = true
                        }
                }
            }
        }
    }
}

final class TextViewCoordinator: NSObject, UITextViewDelegate {
    private let parent: TextViewRepresentable

    init(_ parent: TextViewRepresentable) {
        self.parent = parent
    }

    private func setIsEditing(to value: Bool) {
        DispatchQueue.main.async {
            self.parent.isEditing = value
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        true
    }

    func textViewDidChange(_ textView: UITextView) {
        parent.text = textView.text

        textView.fitTextToBounds(maxSize: 100)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        setIsEditing(to: true)
    }

    func textViewDidEndEditing(_: UITextView) {
        setIsEditing(to: false)
    }
}

struct TextViewRepresentable: UIViewRepresentable {
    @Binding fileprivate var text: String
    @Binding fileprivate var isEditing: Bool

    private let font: UIFont
    private let textHorizontalPadding: CGFloat
    private let textVerticalPadding: CGFloat
    private let textColor: UIColor
    private let backgroundColor: UIColor
    private let returnType: UIReturnKeyType
    private let keyboardDismissMode: UIScrollView.KeyboardDismissMode
    private let isEditable: Bool
    private let isSelectable: Bool
    private let isScrollingEnabled: Bool

    init(
        text: Binding<String>,
        isEditing: Binding<Bool>,
        textHorizontalPadding: CGFloat,
        textVerticalPadding: CGFloat,
        textColor: UIColor,
        backgroundColor: UIColor,
        returnType: UIReturnKeyType,
        keyboardDismissMode: UIScrollView.KeyboardDismissMode,
        isEditable: Bool,
        isSelectable: Bool,
        isScrollingEnabled: Bool
    ) {
        _text = text
        _isEditing = isEditing

        self.font = UIFont.systemFont(ofSize: 100)
        self.textHorizontalPadding = textHorizontalPadding
        self.textVerticalPadding = textVerticalPadding
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.returnType = returnType
        self.keyboardDismissMode = keyboardDismissMode
        self.isEditable = isEditable
        self.isSelectable = isSelectable
        self.isScrollingEnabled = isScrollingEnabled
    }

    func makeCoordinator() -> TextViewCoordinator {
        .init(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = VerticallyCenteredTextView()
        textView.delegate = context.coordinator
        textView.font = font

        let item = textView.inputAssistantItem
        item.leadingBarButtonGroups = []
        item.trailingBarButtonGroups = []

        textView.reloadInputViews()

        return textView
    }

    func updateUIView(_ textView: UITextView, context _: Context) {
        if textView.markedTextRange == nil {
            let textViewWasEmpty = textView.text.isEmpty
            let oldSelectedRange = textView.selectedTextRange

            textView.text = text
            textView.selectedTextRange = textViewWasEmpty
                ? textView.textRange(
                    from: textView.endOfDocument,
                    to: textView.endOfDocument
                )
                : oldSelectedRange
        }

        textView.textAlignment = .center
        textView.textColor = textColor
        textView.backgroundColor = backgroundColor
        textView.returnKeyType = returnType
        textView.keyboardDismissMode = keyboardDismissMode
        textView.autocorrectionType = .no
        textView.keyboardType = .asciiCapable
        textView.isEditable = isEditable
        textView.isSelectable = isSelectable
        textView.isScrollEnabled = isScrollingEnabled

        textView.textContainerInset = .init(
            top: textVerticalPadding,
            left: textHorizontalPadding,
            bottom: textVerticalPadding,
            right: textHorizontalPadding
        )

        textView.textContainer.maximumNumberOfLines = 100

        let toolbar = UIToolbar(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        )
        toolbar.items = [
            .flexibleSpace(),
            .init(
                title: nil,
                image: UIImage(systemName: "keyboard.chevron.compact.down"),
                primaryAction: .init { _ in
                    textView.resignFirstResponder()
                },
                menu: nil
            )
        ]
        toolbar.tintColor = .white
        textView.inputAccessoryView = toolbar

        DispatchQueue.main.async {
            _ = self.isEditing
                ? textView.becomeFirstResponder()
                : textView.resignFirstResponder()
        }
    }
}

extension UITextView {
    func fitTextToBounds(maxSize: CGFloat) {
        guard let text = text else { return }
        let font = self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        self.font = UIFont.fontFittingText(
            text,
            in: textBoundingBox.size,
            fontDescriptor: font.fontDescriptor,
            maxSize: maxSize
        )
    }

    private var textBoundingBox: CGRect {
        var textInsets: UIEdgeInsets = textContainerInset
        textInsets.left += textContainer.lineFragmentPadding
        textInsets.right += textContainer.lineFragmentPadding
        return bounds.inset(by: textInsets)
    }
}

extension UIFont {
    fileprivate static func fontFittingText(
        _ text: String,
        in bounds: CGSize,
        fontDescriptor: UIFontDescriptor,
        maxSize: CGFloat
    ) -> UIFont? {
        let properBounds = CGRect(origin: .zero, size: bounds)
        let largestFontSize = Int(bounds.height)
        let constrainingBounds = CGSize(width: properBounds.width, height: CGFloat.infinity)

        let bestFittingFontSize: Int? = (1...largestFontSize).reversed().first(where: { fontSize in
            let font = UIFont(descriptor: fontDescriptor, size: CGFloat(fontSize))
            let currentFrame = text.boundingRect(
                with: constrainingBounds,
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: font],
                context: nil
            )

            if properBounds.contains(currentFrame) {
                return true
            }

            return false
        })

        guard let fontSize = bestFittingFontSize else { return nil }
        let boundedSize = min(CGFloat(fontSize), maxSize)
        return UIFont(descriptor: fontDescriptor, size: boundedSize)
    }
}
