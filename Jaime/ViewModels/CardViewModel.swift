//
//  CardViewModel.swift
//  Jaime
//
//  Created by Paul on 2019-06-16.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import Foundation
import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    //define properties that view will display/render
    let imageName: String
    let attributedString: NSAttributedString
    let texAllignment: NSTextAlignment
}
