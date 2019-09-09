//
//  MessagesNavBar.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-08.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import LBTATools

class MessagesNavBar: UIView {

    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "kelly4"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Username", font:  .systemFont(ofSize: 16))
    let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.9365855455, green: 0.385594368, blue: 0.3769437671, alpha: 1))
    let flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 0.9365855455, green: 0.385594368, blue: 0.3769437671, alpha: 1))
    private let match: Match

    init(match: Match) {
        self.match = match
        nameLabel.text = match.name
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl))

        super.init(frame: .zero)
        backgroundColor = .white

        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))

        userProfileImageView.constrainWidth(44)
        userProfileImageView.constrainHeight(44)
        userProfileImageView.clipsToBounds = true
        userProfileImageView.layer.cornerRadius = 44 / 2

        let middleStack = hstack(
            stack(
                userProfileImageView,
                nameLabel,
                alignment: .center),
            alignment: .center
        )

        hstack(backButton.withWidth(50),
               middleStack,
               flagButton.withWidth(50)).withMargins(.init(top: 0, left: 4, bottom: 0, right: 4))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
