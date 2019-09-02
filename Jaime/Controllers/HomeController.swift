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

class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()

    var cardViewModels = [CardViewModel]() // empty array

    override func viewDidLoad() {
        super.viewDidLoad()

        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)

        setupLayout()
        fetchCurrentUser()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("HomeController did appear")
        // you want to kick the user out when they log out
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)
            present(navController, animated: true)
        }
    }

    func didFinishLoggingIn() {
        fetchCurrentUser()
    }

    fileprivate let hud = JGProgressHUD(style: .dark)
    fileprivate var user: User?

    fileprivate func fetchCurrentUser() {
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                self.hud.dismiss()
                return
            }
            self.user = user
            self.fetchUsersFromFirestore()
        }
    }

    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }

    var topCardView: CardView?

    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        let duration = 0.5
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        rotationAnimation.duration = 1

        let cardView = topCardView
        topCardView = cardView?.nextCardView

        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }

        cardView?.layer.add(translationAnimation, forKey: "position")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")

        CATransaction.commit()
    }

    @objc func handleLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 15)
    }

    fileprivate func saveSwipeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        guard let cardUID = self.topCardView?.cardViewModel.uid else { return }
        let documentData = [cardUID: didLike]
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch swipe document:", err)
                return
            }

            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    //success
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    //success
                }
            }
        }
    }

    @objc func handleDislike() {
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -15)
    }

    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }

    var lastFetchedUser: User?

    fileprivate func fetchUsersFromFirestore() {
        let minSeekingAge = user?.minSeekingAge ?? SettingsTableViewController.defaultMinSeekingAge
        let maxSeekingAge = user?.maxSeekingAge ?? SettingsTableViewController.defaultMaxSeekingAge

        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minSeekingAge).whereField("age", isLessThanOrEqualTo: maxSeekingAge)
        topCardView = nil
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err {
                print("Failed to fetch users:", err)
                return
            }

            var previousCardView: CardView?

            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                //don't want user to see themself
                if user.uid != Auth.auth().currentUser?.uid {
                    let cardView = self.setupCardFromUser(user: user)

                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView

                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }

    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsControllerViewController()
        userDetailsController.cardViewModel = cardViewModel
        present(userDetailsController, animated: true)
    }

    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardView.delegate = self
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }

    @objc func handleSettings() {
        let settingsController = SettingsTableViewController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }

    func didSaveSettings() {
        print("Notified of dismissal from SettingsController in HomeController")
        fetchCurrentUser()
    }

    // MARK:- Fileprivate

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

}

