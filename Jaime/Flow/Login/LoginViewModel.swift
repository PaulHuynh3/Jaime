//
//  LoginViewModel.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-08-25.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import Foundation
import Firebase

class LoginViewModel {

    var isLoggingIn = Bindable<Bool>()
    var isFormValid = Bindable<Bool>()

    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }

    fileprivate func checkFormValidity() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }

    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        isLoggingIn.value = true
        FirebaseRepository.shared.signIn(email: email, password: password) { err in
            completion(err)
        }
    }
}
