//
//  HomeController.swift
//  Jaime
//
//  Created by Paul on 2019-06-15.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    
    fileprivate let cardsDeckView = UIView()
    fileprivate let topStackView = TopNavigationStackView()
    fileprivate let bottomControls = HomeBottomControlsStackView()

    var cardViewModels = [CardViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingsButton.addTarget(self, action:#selector(navigateToProfile), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        setupLayout()
        setupFirestoreUserCards()
        fetchUserFromFirestore()
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
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }

    @objc fileprivate func handleRefresh() {
        fetchUserFromFirestore()
    }

    var lastFetchUser: User?

    fileprivate func fetchUserFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        //introduce pagination
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments { (querySnapshot, error) in
            hud.dismiss()
            if let error = error {
                print("Failed to fetch users", error)
                return
            }
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchUser = user
                self.setupCardFromUser(user: user)
            })
        }
    }

    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView() //CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView) //fix flashing
        cardView.fillSuperview()
    }

    @objc func navigateToProfile() {
        print("Navigating to profile")
        let registrationViewController = RegistrationViewController()
        present(registrationViewController, animated: true)
    }
    
}

/*
 //how to query
 let query = Firestore.firestore().collection("users").whereField("profession", isEqualTo: "Teacher")
 let query = Firestore.firestore().collection("users").whereField("age", isGreaterThan: 18).whereField("age", isLessThan: 27)
 */
