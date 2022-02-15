//
//  AuthView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 14.02.2022.
//

import SwiftUI
import Firebase

struct AuthView: View {

    @ObservedObject private var otpCodeManager: OtpInputManager
    @Binding var authMode: AuthMode
    @FocusState private var focusedField: FocusField?
    let phoneNumber: String
    let lenghOfOtp: Int = 6//Get in touch we have 6 digits otp code
    let textBoxWidth = UIScreen.main.bounds.width / 8
    let textBoxHeight = UIScreen.main.bounds.width / 8
    let spaceBetweenBoxes: CGFloat = 10
    let paddingOfBox: CGFloat = 1
    var textFieldOriginalWidth: CGFloat {
        (textBoxWidth*6)+(spaceBetweenBoxes*3)+((paddingOfBox*2)*3)
    }

    init(authMode: Binding<AuthMode>, phoneNumber: String) {
        self._authMode = authMode
        self.phoneNumber = phoneNumber
        UITextField.appearance().keyboardAppearance = .dark
        self.otpCodeManager = OtpInputManager(limit: 6)
    }

    var body: some View {
        NavigationView {
            VStack {
                header
                ZStack {
                    textBoxes
                        .onTapGesture {
                            focusedField = FocusField.field
                        }
                        .offset(x: otpCodeManager.status == .uncecess ? -5 : 0)
                        .animation(Animation.default.repeatCount(3).speed(3), value: otpCodeManager.status)
                    TextField("", text: $otpCodeManager.text)
                        .frame(width: focusedField == FocusField.field ? 0 : textFieldOriginalWidth, height: textBoxHeight)
                        .foregroundColor(.clear)
                        .accentColor(.clear)
                        .background(Color.clear)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .focused($focusedField, equals: .field)
                        .task {
                            self.focusedField = .field
                        }
                }
                .padding(.bottom, 229)
            }
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        authMode = .sign
                    } label: {
                        Image("arrow_right")
                    }
                }
            }
        }
    }

    var textBoxes: some View {

        let separateCode: [Int:String] = separateOTP(otp: otpCodeManager.text)
        var arrayOfBoxesView: Array<AnyView> = []

        for index in 0...lenghOfOtp - 1 {
            if let ch = separateCode[index] {
                arrayOfBoxesView.append(AnyView(otpText(ch)))
            } else {
                arrayOfBoxesView.append(AnyView(otpText("")))
            }
        }
        return HStack (spacing: spaceBetweenBoxes) {
            ForEach(arrayOfBoxesView.indices, id: \.self) { index in
                arrayOfBoxesView[index]
            }
        }
    }

    private func otpText(_ text: String) -> some View {
        return Text(text)
            .font(Font.custom("ALSHauss-Medium", size: 24))
            .foregroundColor(.white)
            .frame(width: textBoxWidth, height: textBoxHeight)
            .background(VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 1)
                    .frame(height: 0.5)
                    .foregroundColor(.white)
            })
            .padding(paddingOfBox)
    }

    var header: some View {
        VStack {
            Text("6-Digit Code")
                .foregroundColor(.white)
                .font(Font.custom("ALSHauss-Medium", size: 24))
                .multilineTextAlignment(.center)
                .padding(.bottom, 12)
                .padding(.leading, 48)
                .padding(.trailing, 48)
            Text("Please enter the code we've send to")
                .foregroundColor(.white)
                .font(Font.custom("ALSHauss-Regular", size: 16))
                .multilineTextAlignment(.center)
                .padding(.leading, 62)
                .padding(.trailing, 62)
                .opacity(0.8)
            Text("\(phoneNumber)")
                .foregroundColor(.green)
                .font(Font.custom("ALSHauss-Regular", size: 16))
                .padding(.bottom, 48)
                .multilineTextAlignment(.center)
                .padding(.leading, 62)
                .padding(.trailing, 62)
                .opacity(0.8)

        }
    }
}

private enum FocusField: Hashable {
    case field
}

private enum Statuses {
    case sucess, uncecess, none
}

private class OtpInputManager: ObservableObject {

    @Published var status: Statuses = .none
    @Published var text = "" {
        didSet {
            if text.count >= characterLimit {
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                status = sign(id: verificationID, verificationCode: text)
                if status == .uncecess {
                    text = ""
                }
            }
        }
        willSet {
            if text.count == 0, status == .uncecess {
                status = .none
            }
        }
    }

    let characterLimit: Int
    init(limit: Int = 6){
        characterLimit = limit
    }
}

private func separateOTP(otp: String) -> [Int:String] {
    var result = [Int:String]()
    guard otp != "" else {
        return result
    }
    for index in 0...otp.indices.count - 1 {
        result[index] = String(Array(otp)[index])
    }
    return result
}

private func sign(id: String?, verificationCode: String) -> Statuses {

    var result: Statuses = .uncecess

    guard let verificationID = id else {
        return .uncecess
    }

    let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: verificationID,
        verificationCode: verificationCode
    )

    Auth.auth().signIn(with: credential) { authResult, error in
        if let error = error {
            result = .uncecess
            print(error)
           // self.showMessagePrompt(error.localizedDescription)
        }

        if let authResult = authResult {
            result = .sucess
        }
    }

    return result

}
