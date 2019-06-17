//
//  ViewController.swift
//  Jaime
//
//  Created by Paul on 2019-06-15.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let buttonsStackView = HomeBottomControlsStackView()
    let cardsDeckView = UIView()
    let navigationStackView = TopNavigationStackView()
    
    let cardViewModels = [
        User(name: "Kelly", age: 23, profession: "Music DJ", imageName: "lady5c").toCardViewModel(),
        User(name: "Jane", age: 18, profession: "Teacher", imageName: "lady4c").toCardViewModel()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
    }
    
    fileprivate func setupDummyCards() {
        
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView() //CardView(frame: .zero)
            cardView.imageView.image = UIImage(named: cardViewModel.imageName)
            cardView.informationLabel.attributedText = cardViewModel.attributedString
            cardView.informationLabel.textAlignment = cardViewModel.texAllignment
            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }

    /// MARK:- Fileprivate
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [navigationStackView, cardsDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
}

