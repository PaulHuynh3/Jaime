//
//  ViewController.swift
//  Jaime
//
//  Created by Paul on 2019-06-15.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let buttonsStackView = HomeBottomControlsStackView()
    let blueView = UIView()
    let navigationStackView = TopNavigationStackView()


    override func viewDidLoad() {
        super.viewDidLoad()
        blueView.backgroundColor = .blue
        setupLayout()
    }

    /// MARK:- Fileprivate
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [navigationStackView, blueView, buttonsStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
}

