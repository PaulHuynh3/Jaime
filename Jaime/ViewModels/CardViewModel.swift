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

class CardViewModel {
    //define properties that view will display/render
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAllignment: NSTextAlignment

    init(imageNames: [String], attributedString: NSAttributedString, textAllignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAllignment = textAllignment
    }

    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = imageNames[imageIndex]
            imageTappedCallback?(imageUrl, imageIndex)
        }
    }

    var imageTappedCallback: ((String?, Int) -> ())?

    func showNextPicture() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }

    func showPreviousPicture() {
        imageIndex = max(0, imageIndex - 1)
    }
}
