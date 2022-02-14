//
//  AuthView.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 14.02.2022.
//

import SwiftUI

struct AuthView: View {

    @State var smsCode: String = ""
    @Binding var authMode: Bool
    let phoneNumber: String
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    @FocusState private var focusedField: FocusField?

    var body: some View {
        NavigationView {
            VStack {
                header
                TextField("code", text: $smsCode)
                    .foregroundColor(.white)
                    //.opacity(0.15)
                    .font(Font.custom("ALSHauss-Medium", size: 24))
                    .padding(.leading, 48)
                    .padding(.trailing, 48)
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .field)
                    .task {
                        self.focusedField = .field
                    }
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.white.opacity(0.8), lineWidth: 2)
//                            .frame(height: 48, alignment: .center)
//                            .padding(.leading, 40)
//                            .padding(.trailing, 40)
//                    }
            }
            .frame(maxHeight: .infinity)
            .background(Color.black)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        authMode.toggle()
                    } label: {
                        Image("arrow_right")
                    }
                }
            }
        }
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
            Text("Please enter the code we have send to \(phoneNumber)")
                .foregroundColor(.white)
                .font(Font.custom("ALSHauss-Regular", size: 16))
                .padding(.bottom, 48)
                .multilineTextAlignment(.center)
                .padding(.leading, 63)
                .padding(.trailing, 63)
                .opacity(0.8)
        }
    }

    var digitView: some View {

                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 32, height: 48)
                    .foregroundColor(.white)
                    .opacity(0.15)


    }
    
}

private enum FocusField: Hashable {
    case field
}

