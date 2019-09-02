//
//  KeepSwipingButton.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-02.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class KeepSwipingButton: UIButton {

    override func draw(_ rect: CGRect) { //rect is the size of the button
        super.draw(rect)

        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.9628203511, green: 0.1762482226, blue: 0.4307305217, alpha: 1)
        let rightColor = #colorLiteral(red: 0.9657289386, green: 0.3937838078, blue: 0.3189650774, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        let cornerRadius = rect.height / 2
        let maskLayer = CAShapeLayer()

        let maskPath = CGMutablePath()
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)

        //punch out the path
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 4, dy: 4), cornerRadius: cornerRadius).cgPath)

        maskLayer.path = maskPath
        maskLayer.fillRule = .evenOdd
        gradientLayer.mask = maskLayer

        self.layer.insertSublayer(gradientLayer, at: 0)

        layer.cornerRadius = cornerRadius
        clipsToBounds = true

        gradientLayer.frame = rect

        
    }

}
