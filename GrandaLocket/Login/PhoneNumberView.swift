

import SwiftUI
import UIKit
import PhoneNumberKit
import Firebase

struct PhoneNumberView: View {

    @Binding var syncContacts: Bool
    @Binding var phoneNumber: String
    @Binding var destination: AppDestination
    @State var inProgress: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                header
                PhoneNumberField(phoneNumber: $phoneNumber)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 8)
                    .padding(.horizontal,16)
                Toggle(isOn: $syncContacts, label: {
                    Text("Sync Contacts")
                        .foregroundColor(.white)

                })
                    .padding(.bottom, 467)
                    .padding(.horizontal,16)
            }
            .frame(maxHeight: .infinity)
            .background(Palette.blackHard)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    signButton
                }
            }
        }
    }

    var header: some View {
        VStack {
            Text("Sign in to Fire")
                .foregroundColor(.white)
                .font(Typography.headerL)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
                .padding(.horizontal,48)
            Text("Please confirm your country code and enter your phone number")
                .foregroundColor(.white)
                .font(Typography.description)
                .padding(.bottom, 44)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 63)
                .opacity(0.8)
                .lineSpacing(4)

        }
    }

    var signButton: some View {
        return Button {
            inProgress.toggle()
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(phoneNumber.removeWhitespace()
                    //"+16505551234"
                    , uiDelegate: nil) { (verificationID, error) in
                        if let error = error {
                            inProgress.toggle()
                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                        inProgress.toggle()
                    destination = .smsAuth
                    }
        } label: {
            HStack {
                if inProgress {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Next")
                        .foregroundColor(.white)
                        .font(Typography.controlL)
                }
            }
        }
    }

   private func showMessagePrompt(_ error: String) {
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
        textField.font = Typography.headerMUI
        textField.adjustsFontForContentSizeCategory = false
        textField.adjustsFontSizeToFitWidth = false
        textField.countryCodePlaceholderColor = .white.withAlphaComponent(0.5)
        textField.numberPlaceholderColor = .white.withAlphaComponent(0.5)
        textField.keyboardAppearance = .dark
        textField.placeholder = "Phone"
        textField.becomeFirstResponder()
        textField.font = Typography.headerMUI
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
