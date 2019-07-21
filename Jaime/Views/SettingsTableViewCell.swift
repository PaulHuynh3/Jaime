//
//  SettingsTableViewCell.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-07-21.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    class SettingsTextField: UITextField {
        
        override var intrinsicContentSize: CGSize { //fixes the spacing of the title to the tf
            return .init(width: 0, height: 44)
        }

        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect { //spacing between viewcontroller and the textfield's left text
            return bounds.insetBy(dx: 24, dy: 0)
        }
    }

    let textField: UITextField = {
        let tf = SettingsTextField()
        tf.placeholder = "Enter Name"
        return tf
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(textField)
        textField.fillSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
