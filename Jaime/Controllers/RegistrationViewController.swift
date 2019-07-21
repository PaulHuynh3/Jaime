//
//  RegistrationViewController.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-06-23.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationViewController: UIViewController {

    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handlePhotoSelection), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()

    let nameTextField: CustomTextField = {
       let textfield = CustomTextField(padding: 16)
        textfield.placeholder = "Enter full name"
        textfield.backgroundColor = .white
        textfield.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textfield
    }()

    let emailTextField: CustomTextField = {
        let textfield = CustomTextField(padding: 16)
        textfield.placeholder = "Enter email"
        textfield.keyboardType = .emailAddress
        textfield.backgroundColor = .white
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textfield.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textfield
    }()

    let passwordTextfield: CustomTextField = {
        let textfield = CustomTextField(padding: 16)
        textfield.placeholder = "Enter password"
        textfield.isSecureTextEntry = true
        textfield.backgroundColor = .white
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textfield.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textfield
    }()

    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = #colorLiteral(red: 0.8135682344, green: 0.1019940302, blue: 0.3355026245, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .normal)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22 //to make it round it should be half the height
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    fileprivate let gradientLayer = CAGradientLayer()
    let registrationViewModel = RegistrationViewModel()
    let registeringHud = JGProgressHUD(style: .dark)

    lazy var verticalStackView: UIStackView = {
      let sv = UIStackView(arrangedSubviews: [
        nameTextField,
        emailTextField,
        passwordTextfield,
        registerButton
        ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()

    //lazy var means stackview is created after buttons, textfield created
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        verticalStackView
        ])

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
        setupNotificationObserver()
        setupTapGesture()
        setupRegistrationViewModelObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self) //prevent retain cycles
    }

    override func viewWillLayoutSubviews() { //basically called when view changes
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds //expand the gradient to support landscape
    }

    // MARK:- Functions

    @objc fileprivate func handlePhotoSelection() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }

    @objc fileprivate func handleRegistration() {
        self.dismissKeyboard()
        registrationViewModel.performRegistration { err in
            if let err = err {
                self.showHUDWithErorr(err: err)
                return
            }
        }
    }

    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == nameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }

    fileprivate func showHUDWithErorr(err: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed"
        hud.detailTextLabel.text = err.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }

    fileprivate func setupRegistrationViewModelObservers() {
        registrationViewModel.bindableIsFormValidObserver.bind { [weak self] isFormValid  in
            guard let isFormValid = isFormValid else { return }
            self?.registerButton.isEnabled = isFormValid
            if isFormValid {
                self?.registerButton.setTitleColor(.white, for: .normal)
                self?.registerButton.backgroundColor = #colorLiteral(red: 0.8135682344, green: 0.1019940302, blue: 0.3355026245, alpha: 1)
            } else {
                self?.registerButton.backgroundColor = .lightGray
                self?.registerButton.setTitleColor(.gray, for: .normal)
            }
        }

        registrationViewModel.bindableImage.bind { [weak self] image in
            self?.selectPhotoButton.setImage(image, for: .normal)
        }

        registrationViewModel.bindableIsRegistering.bind { [weak self] isRegistering in
            if isRegistering == true {
                self?.registeringHud.show(in: self?.view ?? UIView())
                self?.registeringHud.textLabel.text = "Registering"
            } else {
                self?.registeringHud.dismiss()
            }
        }
    }

    fileprivate func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }

    fileprivate func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue

        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height

        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }

    @objc fileprivate func handleKeyboardWillDismiss(notification: Notification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }

    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.9893777966, green: 0.347874403, blue: 0.382784009, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.9005830884, green: 0.127312541, blue: 0.4597411752, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
    }
    //check if landscape vs portrait
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }

    fileprivate func setupLayout() {
        view.addSubview(overallStackView)
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        overallStackView.spacing = 8
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image?.withRenderingMode(.alwaysOriginal)
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
