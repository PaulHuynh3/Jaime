//
//  RegistrationViewModel.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-06-26.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class RegistrationViewModel {

    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValidObserver = Bindable<Bool>()
    var firebaseRepository = FirebaseRepository.shared

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

    func checkFormValiditity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        bindableIsFormValidObserver.value = isFormValid
    }

    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email else { return }
        guard let password = password else { return }
        bindableIsRegistering.value = true
        firebaseRepository.createUser(email: email, password: password) { (err) in
            if let err = err {
                completion(err)
                return
            }
            self.saveImageToFirebase(completion: completion)
        }
    }

    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        let fileName = UUID().uuidString
        firebaseRepository.saveImageToStorage(fileName: fileName, image: bindableImage.value ?? UIImage()) { (url, err) in
            if let err = err {
                completion(err)
                return
            }
            self.saveInfoToFirestore(imageUrl: url?.absoluteString ?? "") { err in
                self.bindableIsRegistering.value = false
                if let err = err {
                    completion(err)
                    return
                }
                completion(nil)
            }
        }
    }

    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = firebaseRepository.userUid
        let userDataDict: [String: Any] = ["fullName": self.fullName ?? "",
                            "uid": uid,
                            "imageUrl1": imageUrl,
                            "age": 18,
                            "minSeekingAge": SettingsTableViewController.defaultMinSeekingAge,
                            "maxSeekingAge": SettingsTableViewController.defaultMaxSeekingAge
            ]
        firebaseRepository.saveInfoToFireStore(withPath: "users", userDict: userDataDict) { (err) in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
        }
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
 //this completion handler gets called when didSelectImageInImagePicker gets called
        self.selectPhotoButton.setImage(image, .normal)
    }
 }

 ImagePicker function:
 func didSelectImageInImagePicker() {
    self.viewModel.image = image
 }
 */
