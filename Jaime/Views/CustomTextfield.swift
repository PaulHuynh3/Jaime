//
//  CustomTextfield.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-06-23.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    let padding: CGFloat

    init(padding: CGFloat) {
        self.padding = padding
        //when initializing textfield set the corner radius to 25
        super.init(frame: .zero)
        layer.cornerRadius = 25
    }

    //provides padding for textfield
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    //provides padding for editing text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
