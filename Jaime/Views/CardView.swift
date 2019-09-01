//
//  CardView.swift
//  Jaime
//
//  Created by Paul on 2019-06-16.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didRemoveCard(cardView: CardView)
}

class CardView: UIView {

    var nextCardView: CardView?

    var delegate: CardViewDelegate?

    var cardViewModel: CardViewModel! {
        didSet{
//            let imageName = cardViewModel.imageUrls.first ?? ""
//            if let url = URL(string: imageName) {
//                imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "app_icon"), options: .continueInBackground)
//            }
            swipingPhotosController.cardViewModel = self.cardViewModel
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAllignment
            
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColour
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white

            setupImageCallback()
        }
    }

    fileprivate func setupImageCallback() {
        cardViewModel.imageTappedCallback = { [weak self] imageUrl, index in
            self?.barsStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = self?.barDeselectedColour
            })
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    // encapsulation
    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    fileprivate let barsStackView = UIStackView()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    
    // configurations
    fileprivate let threshold: CGFloat = 100
    fileprivate let barDeselectedColour = UIColor(white: 0, alpha: 0.1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        //execute when view draws itself
        //On it's initializer the frame is 0
        gradientLayer.frame = self.frame
    }

    fileprivate let moreinfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()

    @objc fileprivate func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true

        let swipingPhotosView = swipingPhotosController.view!
        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
        
        setupGradientLayer()

        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.numberOfLines = 0

        addSubview(moreinfoButton)
        moreinfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
    }
    
    fileprivate func setupGradientLayer() {
        //draw a gradient with swift
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1] //0.5 is middle
        layer.addSublayer(gradientLayer)
    }

    //abstract this logic into cardViewModel
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvanceNextPhoto {
            cardViewModel.showNextPicture()
        } else {
            cardViewModel.showPreviousPicture()
        }
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            //animations become unpredictable thus remove it when discarding the cards.
            superview?.subviews.forEach({ (cardView) in
                cardView.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        //handle rotation
        //convert radients to degrees
        let translation = gesture.translation(in: nil)
        print(translation.x)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        
        transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            if shouldDismissCard {
                self.frame = CGRect(x: 1000 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
        }) { (_) in
            //arrange the view back to its original position
            self.transform = .identity
            if shouldDismissCard {
               self.removeFromSuperview()
                self.delegate?.didRemoveCard(cardView: self)
            }
        }
    }

}
