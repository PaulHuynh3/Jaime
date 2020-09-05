//
//  UserDetailsControllerViewController.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-08-25.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class UserDetailsControllerViewController: UIViewController, UIScrollViewDelegate {

    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            guard let firstImageUrl = cardViewModel.imageUrls.first, let url = URL(string: firstImageUrl) else { return }
            swipingPhotosController.cardViewModel = cardViewModel
        }
    }

    //lazy soo the function is able to access self
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        //for draggin the image without the safearea bounce
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()

    let swipingPhotosController = SwipingPhotosController()

    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name 30\nDoctor\nSome bio text down below"
        label.numberOfLines = 0
        return label
    }()

    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return button
    }()

    //3 bottom control buttons
    lazy var dislikeButton = self.createButton(image: #imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), selector: #selector(handleDislike))
    lazy var superLikeButton = self.createButton(image: #imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), selector: #selector(handleDislike))
    lazy var likeButton = self.createButton(image: #imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), selector: #selector(handleDislike))

    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }

    @objc fileprivate func handleDislike() {
        //handle dislike
    }

    fileprivate let extraSwipingHeight: CGFloat = 140

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupLayout()
        setupVisualBlurEffectView()
        setupBottomControls()

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let swipingView = swipingPhotosController.view!
        //use fram inside uiscrollview instead of autolayout (anchors like for label)
        swipingView.frame = CGRect(x: 0, y: 0, width:  view.frame.width, height: view.frame.width + extraSwipingHeight)
    }

    fileprivate func setupBottomControls() {
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        stackView.distribution = .fillEqually
        stackView.spacing = -32
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 80))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }

    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        let swipingView = swipingPhotosController.view!
        scrollView.addSubview(swipingView)
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: swipingView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))

        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 25), size: .init(width: 50, height: 50))
    }

    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let imageView = swipingPhotosController.view!
        //expand the frame of image using the contentOffSet
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        //prevent the image from going small if i scroll up
        width = max(view.frame.width, width)
        //minimum value prevents the image from shifting left and right
        imageView.frame = CGRect(x: min(0, -changeY) , y: min(0, -changeY), width: width, height: width)
    }

}
