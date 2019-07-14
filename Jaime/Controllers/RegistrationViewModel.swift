//
//  RegistrationViewModel.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-06-26.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class RegistrationViewModel {

    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValidObserver = Bindable<Bool>()

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
        bindableIsFormValidObserver.value = isFormValid
    }

}

/* //Reactive programming to for MVVM
 Create observer in viewModel:
 var image = {
    didSet {
        imageObserver?(image)
    }
 }
 var imageObserver: ((UIImage?) -> ())?


 Set up observers in viewDidLoad of viewControler:
 func setupObserver() {
    imageObserver = { [weak self] image in
        self.selectPhotoButton.setImage(image, .normal)
    }
 }

 ImagePicker function:
 func didSelectImageInImagePicker() {
    self.viewModel.image = image
 }
 */
