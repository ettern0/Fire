

import SwiftUI
import UIKit
import PhoneNumberKit
import Firebase

struct SignView: View {

    @Binding var syncContacts: Bool
    @Binding var phoneNumber: String
    @Binding var authMode: Bool

    var body: some View {
        NavigationView {
            VStack {
                header
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: 68)
                PhoneNumberField(phoneNumber: $phoneNumber)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 27)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                Toggle(isOn: $syncContacts, label: {
                    Text("Sync Contacts")
                        .foregroundColor(.white)
                })
                    .padding(.bottom, 105)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
            }
            .frame(maxHeight: .infinity)
            .background(Color.black)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    signButton
                }
            }
        }
    }

    var header: some View {
        VStack {
            Text("Sign in to Granda Locket")
                .foregroundColor(.white)
                .font(Font.custom("ALSHauss-Medium", size: 24))
                .multilineTextAlignment(.center)
                .padding(.bottom, 12)
                .padding(.leading, 48)
                .padding(.trailing, 48)
            Text("Please confirm your country code and enter your phone number.")
                .foregroundColor(.white)
                .font(Font.custom("ALSHauss-Regular", size: 16))
                .padding(.bottom, 48)
                .multilineTextAlignment(.center)
                .padding(.leading, 63)
                .padding(.trailing, 63)
                .opacity(0.8)
        }
    }

    var signButton: some View {
        return Button {
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(
                    //phoneNumber.removeWhitespace()
                    "+16505551234"
                    , uiDelegate: nil) { (verificationID, error) in
                        if let error = error {
                            self.showMessagePrompt(error.localizedDescription)

                            return
                        }
                        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                        authMode.toggle()
                    }
        } label: {
            Text("Next")
                .foregroundColor(.white)
                .font(Font.custom("ALSHauss-Regular", size: 16))
        }
    }

    func showMessagePrompt(_ error: String) {
        print(error)
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
        textField.font = UIFont(name: "ALSHauss-Regular", size: 20)
        textField.adjustsFontForContentSizeCategory = false
        textField.adjustsFontSizeToFitWidth = false
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
