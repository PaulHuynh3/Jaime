//
//  RegistrationViewModel.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-06-26.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {

    var bindableIsRegistering = Bindable<Bool>()
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

    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email else { return }
        guard let password = password else { return }
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let err = error {
                completion(err)
                return
            }
            self.saveImageToFirebase(completion: completion)
        }
    }

    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            if let err = err {
                completion(err)
                return
            }
            ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                self.bindableIsRegistering.value = false
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })
        })
    }

    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let documentData = ["fullName": self.fullName ?? "", "uid": uid, "imageUrl1": imageUrl]
        Firestore.firestore().collection("users").document(uid).setData(documentData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
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
 //this completion handler gets called when didSelectImageInImagePicker gets called
        self.selectPhotoButton.setImage(image, .normal)
    }
 }

 ImagePicker function:
 func didSelectImageInImagePicker() {
    self.viewModel.image = image
 }
 */
