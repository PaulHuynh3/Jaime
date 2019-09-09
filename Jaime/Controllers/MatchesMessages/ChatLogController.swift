//
//  ChatLogController.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-08.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import LBTATools

struct Message {
    let text: String
}

class MessageCell: LBTAListCell<Message> {
    override var item: Message! {
        didSet {
            backgroundColor = .red
        }
    }
}

class ChatLogController: LBTAListController<MessageCell, Message> , UICollectionViewDelegateFlowLayout {

    fileprivate lazy var customNavBar = MessagesNavBar(match: self.match) //lazy var means the customNavBar will be created after the variable match is created
    fileprivate let navBarHeight: CGFloat = 120
    fileprivate let match: Match

    init(match: Match) {
        self.match = match
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        items = [ .init(text: "Helllooo"), .init(text: "safsagfasgsa") ]

        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))

        collectionView.contentInset.top = navBarHeight
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }

    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 15, left: 0, bottom: 15, right: 0)
    }


}
