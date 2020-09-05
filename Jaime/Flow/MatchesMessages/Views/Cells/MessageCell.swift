//
//  MessageCell.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-08.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import LBTATools

class MessageCell: LBTAListCell<Message> {

    var textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()

    let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 0.8753404021, green: 0.870375216, blue: 0.8747211099, alpha: 1))


    override var item: Message! {
        didSet {
            textView.text = item.text

            if item.isFromCurrentLoggedUser {
                //messages on right
                anchoredConstraints.trailing?.isActive = true
                anchoredConstraints.leading?.isActive = false
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.07885210961, green: 0.762370646, blue: 0.9986745715, alpha: 1)
                textView.textColor = .white
            } else {
                anchoredConstraints.trailing?.isActive = false
                anchoredConstraints.leading?.isActive = true
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.9019486308, green: 0.9019110203, blue: 0.9061665535, alpha: 1)
                textView.textColor = .black
            }
        }
    }

    var anchoredConstraints: AnchoredConstraints!

    override func setupViews() {
        super.setupViews()
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        anchoredConstraints = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)

        anchoredConstraints.leading?.constant = 20
        anchoredConstraints.trailing?.isActive = false
        anchoredConstraints.trailing?.constant = -20
        //make messages appear on right we would do anchoredConstraits.leading?.isActive = false

        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true

        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12)) //fill superview of bubble container
    }
}
