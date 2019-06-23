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
    let imageNames: [String]
    
    func toCardViewModel() -> CardViewModel {
        let attrubutedText = NSMutableAttributedString(string: name, attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        attrubutedText.append(NSAttributedString(string: "  \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular), .foregroundColor: UIColor.white]))
        attrubutedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular), .foregroundColor: UIColor.white]))
        return CardViewModel(imageNames: imageNames, attributedString: attrubutedText, textAllignment: .left)
    }
}
