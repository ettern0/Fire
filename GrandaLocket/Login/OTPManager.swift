//
//  OTPManager.swift
//  GrandaLocket
//
//  Created by Сердюков Евгений on 15.02.2022.
//

import Foundation
import Firebase
import Combine

final class OtpInputManager: ObservableObject {
    @Published var status: StatusAuth = .idle
    @Published var text = ""
    @Published var inProgress: Bool = false

    let characterLimit: Int
    private var cancellable: Cancellable?

    init(limit: Int = 6) {
        characterLimit = limit

        cancellable = $text.removeDuplicates().sink { [weak self] text in
            guard let self = self else { return }
            if text.count >= self.characterLimit {
                print("~ \(text)")
                self.inProgress.toggle()
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                sign(id: verificationID, verificationCode: text) { status in
                    if status == .failure {
                        self.text = ""
                    }
                    self.status = status
                    self.inProgress.toggle()
                }
            } else {
                self.status = .idle
            }
        }
    }
}

private func sign(id: String?, verificationCode: String, completion: @escaping (StatusAuth) -> Void) {

    var result: StatusAuth = .failure

    guard let verificationID = id else {
        return completion(result)
    }

    let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: verificationID,
        verificationCode: verificationCode
    )

    Auth.auth().signIn(with: credential) { authResult, error in
        if let error = error {
            result = .failure
            print(error)
           print(error.localizedDescription)
        }

        if authResult != nil {
            result = .success
        }

        completion(result)
    }
}
