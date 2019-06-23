//
//  Advertiser.swift
//  Jaime
//
//  Created by Paul on 2019-06-16.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let posterPhotoName: String
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy), .foregroundColor: UIColor.white])
        
        attributedString.append(NSAttributedString(string: "\n\(brandName)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold), .foregroundColor: UIColor.white]))
        
        return CardViewModel(imageNames: [posterPhotoName], attributedString: attributedString, textAllignment: .center)
    }
}


