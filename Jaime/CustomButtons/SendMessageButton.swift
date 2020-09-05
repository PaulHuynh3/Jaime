//
//  SendMessageButton.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-02.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.9628203511, green: 0.1762482226, blue: 0.4307305217, alpha: 1)
        let rightColor = #colorLiteral(red: 0.9657289386, green: 0.3937838078, blue: 0.3189650774, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        self.layer.insertSublayer(gradientLayer, at: 0)

        layer.cornerRadius = rect.height / 2
        clipsToBounds = true

        gradientLayer.frame = rect
    }

}
