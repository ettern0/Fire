

import SwiftUI
import UIKit
import PhoneNumberKit

struct SignView: View {

    @State var phoneNumber: String = ""

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            PhoneNumberField(phoneNumber: $phoneNumber)
                .padding()
                .frame(height: 20)
                .frame(maxWidth: .infinity)
        }
    }
}

struct PhoneNumberField: UIViewRepresentable {

    @Binding var phoneNumber: String
    private let textField = PhoneNumberTextField()

    func makeUIView(context: Context) -> PhoneNumberTextField {
        textField.withExamplePlaceholder = true
        textField.withFlag = true
        textField.withPrefix = true
        textField.maxDigits = 10
        textField.textColor = .white
        textField.countryCodePlaceholderColor = .white.withAlphaComponent(0.5)
        textField.numberPlaceholderColor = .white.withAlphaComponent(0.5)
        textField.keyboardAppearance = .dark
        textField.placeholder = "Phone"
        textField.becomeFirstResponder()
        textField.font = UIFont.systemFont(ofSize: 32)
        textField.addTarget(context.coordinator, action: #selector(Coordinator.onTextUpdate), for: .editingChanged)
        return textField
    }

    func updateUIView(_ view: PhoneNumberTextField, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {

        var control: PhoneNumberField

        init(_ control: PhoneNumberField) {
            self.control = control
        }

        @objc func onTextUpdate(textField: UITextField) {
            self.control.phoneNumber = textField.text!
        }

    }

}
