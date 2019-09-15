//
//  RecentMessageCell.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-15.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//
import LBTATools

class RecentMessageCell: LBTAListCell<UIColor> {

    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "jane1.jpg"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "USERNAME HERE", font: .boldSystemFont(ofSize: 18))
    let messageTextLabel = UILabel(text: "Some long line of text that should span 2 lines", font: .systemFont(ofSize: 16), textColor: .gray, numberOfLines: 2)

    override var item: UIColor! {
        didSet {
            //            backgroundColor = item
        }
    }

    override func setupViews() {
        super.setupViews()

        userProfileImageView.layer.cornerRadius = 94 / 2

        hstack(userProfileImageView.withWidth(94).withHeight(94),
               stack(usernameLabel, messageTextLabel, spacing: 2),
               spacing: 20,
               alignment: .center
            ).padLeft(20).padRight(20)

        addSeparatorView(leadingAnchor: usernameLabel.leadingAnchor)
    }
}
