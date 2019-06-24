//
//  RegistrationViewController.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-06-23.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()

    let nameTextField: CustomTextField = {
       let textfield = CustomTextField(padding: 16)
        textfield.placeholder = "Enter full name"
        textfield.backgroundColor = .white
        return textfield
    }()

    let emailTextField: CustomTextField = {
        let textfield = CustomTextField(padding: 16)
        textfield.placeholder = "Enter email"
        textfield.keyboardType = .emailAddress
        textfield.backgroundColor = .white
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textfield
    }()

    let passwordTextfield: CustomTextField = {
        let textfield = CustomTextField(padding: 16)
        textfield.placeholder = "Enter password"
        textfield.isSecureTextEntry = true
        textfield.backgroundColor = .white
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textfield
    }()

    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.backgroundColor = #colorLiteral(red: 0.8135682344, green: 0.1019940302, blue: 0.3355026245, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25 //to make it round it should be half the height
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
    }

    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.9893777966, green: 0.347874403, blue: 0.382784009, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.9005830884, green: 0.127312541, blue: 0.4597411752, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }

    fileprivate func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            selectPhotoButton,
            nameTextField,
            emailTextField,
            passwordTextfield,
            registerButton
            ])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
}
