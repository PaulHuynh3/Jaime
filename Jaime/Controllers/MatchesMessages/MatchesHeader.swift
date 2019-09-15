//
//  MatchesHeader.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-15.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import LBTATools

class MatchesHeader: UICollectionReusableView {

    let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.9668447375, green: 0.4182221889, blue: 0.4409095943, alpha: 1))
    let matchesHorizontalController = MatchesHorizontalController()
    let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.9668447375, green: 0.4182221889, blue: 0.4409095943, alpha: 1))

    override init(frame: CGRect) {
        super.init(frame: frame)

        stack(stack(newMatchesLabel).padLeft(20),
              matchesHorizontalController.view,
              stack(messagesLabel).padLeft(20),
              spacing: 20).withMargins(.init(top: 20, left: 0, bottom: 8, right: 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
