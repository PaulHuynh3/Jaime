//
//  User.swift
//  Jaime
//
//  Created by Paul on 2019-06-16.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {

    let name: String
    let age: Int
    let profession: String
    let imageName: String
    
    func toCardViewModel() -> CardViewModel {
        let attrubutedText = NSMutableAttributedString(string: name, attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attrubutedText.append(NSAttributedString(string: "  \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attrubutedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        return CardViewModel(imageName: imageName, attributedString: attrubutedText, texAllignment: .left)
    }
}
