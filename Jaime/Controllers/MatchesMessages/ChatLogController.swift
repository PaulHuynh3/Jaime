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
    let isMessageFromCurrentLoggedUser: Bool
}

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

            if item.isMessageFromCurrentLoggedUser {
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

        collectionView.alwaysBounceVertical = true

        items = [ .init(text: "Helllooo", isMessageFromCurrentLoggedUser: true),
                  .init(text: "safsagfasgsa  i seee a while change", isMessageFromCurrentLoggedUser: false),
                  .init(text: "be there soon", isMessageFromCurrentLoggedUser: true)]

        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))

        collectionView.contentInset.top = navBarHeight
        collectionView.scrollIndicatorInsets.top = navBarHeight
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)

        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }

    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 15, left: 0, bottom: 15, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //estimate size of the message
        let estimatedSizeCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedSizeCell.item = self.items[indexPath.item]
        estimatedSizeCell.layoutIfNeeded()

        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))

        return .init(width: view.frame.width, height: estimatedSize.height)
    }


}
