//
//  MatchesNavBar.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-02.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit
import LBTATools

class MatchesNavBar: UIView {

    let backButton = UIButton(image: #imageLiteral(resourceName: "app_icon"), tintColor: .gray)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        iconImageView.tintColor = #colorLiteral(red: 0.9676375985, green: 0.4422079921, blue: 0.4743079543, alpha: 1)

        let messageLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 0.9676375985, green: 0.4422079921, blue: 0.4743079543, alpha: 1), textAlignment: .center)
        let feedLabel = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 20), textColor: .gray, textAlignment: .center)

        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        stack(iconImageView.withHeight(38), hstack(messageLabel, feedLabel, distribution: .fillEqually)).padTop(10)

        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 34, height: 34))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
