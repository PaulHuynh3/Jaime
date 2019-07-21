//
//  HomeController.swift
//  Jaime
//
//  Created by Paul on 2019-06-15.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    fileprivate let buttonsStackView = HomeBottomControlsStackView()
    fileprivate let cardsDeckView = UIView()
    fileprivate let navigationStackView = TopNavigationStackView()
    
//    let cardViewModels: [CardViewModel] = {
//        let producers: [ProducesCardViewModel] = [
//            Advertiser(title: "Slide Out Menu", brandName: "Coca Cola", posterPhotoName: "slide_out_menu_poster"),
//            User(name: "Kelly", age: 23, profession: "Music DJ", imageNames: ["kelly1","kelly2", "kelly3"]),
//            User(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1", "jane2", "jane3"])
//        ]
//        let viewModels = producers.map({ (producers) -> CardViewModel in
//            return producers.toCardViewModel()
//        })
//        return viewModels
//    }()

    var cardViewModels = [CardViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupFirestoreUserCards()
        setupSettings()
        fetchUserFromFirebase()
    }

    fileprivate func setupSettings() {
        navigationStackView.settingsButton.addTarget(self, action:#selector(navigateToProfile), for: .touchUpInside)
    }

    fileprivate func setupFirestoreUserCards() {
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView() //CardView(frame: .zero)
            cardView.cardViewModel = cardViewModel
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }

    /// MARK:- Fileprivate
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [navigationStackView, cardsDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }

    fileprivate func fetchUserFromFirebase() {

//        let query = Firestore.firestore().collection("users").whereField("profession", isEqualTo: "Teacher")
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThan: 18).whereField("age", isLessThan: 27)
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Failed to fetch users", error)
                return
            }
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
            })
            self.setupFirestoreUserCards()
        }
    }

    @objc func navigateToProfile() {
        print("Navigating to profile")
        let registrationViewController = RegistrationViewController()
        present(registrationViewController, animated: true)
    }
    
}
