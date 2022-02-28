//
//  AuthView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 14.02.2022.
//

import SwiftUI
import Firebase
import Combine

struct SmsView: View {

    @ObservedObject private var otpCodeManager: OtpInputManager
    @Binding var destination: AppDestination
    @FocusState private var focusedField: FocusField?
    let phoneNumber: String
    let lenghOfOtp: Int = 6//Get in touch we have 6 digits otp code
    let paddingOfBox: CGFloat = 1

    init(destination: Binding<AppDestination>, phoneNumber: String) {
        self._destination = destination
        self.phoneNumber = phoneNumber
        UITextField.appearance().keyboardAppearance = .dark
        self.otpCodeManager = OtpInputManager()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {

        }
    }

    var body: some View {
        NavigationView {
            VStack {
                header
                ZStack {
                    if otpCodeManager.inProgress {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        textBoxes
                        TextField("", text: $otpCodeManager.text)
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
                }
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity)
            .background(Palette.blackHard)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.focusedField = .field
                    if phoneNumber == "+16505551234" {
                        self.otpCodeManager.text = "123654"
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        destination = .phoneNumberAuth
                    } label: {
                        Image("arrow_right")
                    }
                }
            }
            .onChange(of: otpCodeManager.status) { status in
                switch status {
                case .idle, .failure:
                    break
                case .success:
                    UserService().saveUserData()
                    destination = .connectContacts
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
        return HStack (spacing: 8) {
            ForEach(arrayOfBoxesView.indices, id: \.self) { index in
                arrayOfBoxesView[index]
            }
        }
    }

    private func otpText(_ text: String) -> some View {
        return Text(text)
            .font(Typography.headerL)
            .foregroundColor(.white)
            .frame(width: 32, height: 48)
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
                .font(Typography.headerL)
                .multilineTextAlignment(.center)
                .padding(.bottom, 12)
                .padding(.horizontal, 63)
            Text("Please enter the code we've send to")
                .foregroundColor(.white)
                .font(Typography.description)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 63)
                .padding(.bottom, 3)
                .opacity(0.8)
                .lineSpacing(4)
            Text("\(phoneNumber)")
                .foregroundColor(.green)
                .font(Typography.description)
                .padding(.bottom, 48)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 63)
                .opacity(0.8)
                .lineSpacing(4)
        }
    }
}

private enum FocusField: Hashable {
    case field
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


