//
//  RegistrationViewModel.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-06-26.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class RegistrationViewModel {

    var fullName: String? {
        didSet {
            checkFormValiditity()
        }
    }
    var email: String? {
        didSet {
            checkFormValiditity()
        }
    }
    var password: String? {
        didSet {
            checkFormValiditity()
        }
    }

    fileprivate func checkFormValiditity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }

    //reactive programming
    var isFormValidObserver: ((Bool) -> ())?

}
