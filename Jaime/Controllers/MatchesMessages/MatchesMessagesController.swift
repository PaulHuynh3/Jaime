//
//  MatchesMessagesController.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-02.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import LBTATools

class MatchCell: LBTAListCell<UIColor> {

    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "kelly2"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Username Here", font: .systemFont(ofSize: 14, weight: .semibold), textColor: #colorLiteral(red: 0.2550676465, green: 0.2552897036, blue: 0.2551020384, alpha: 1), textAlignment: .center, numberOfLines: 2)

    override var item: UIColor! {
        didSet {
            backgroundColor = item
        }
    }

    override func setupViews() {
        super.setupViews()

        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 80 / 2

        stack(stack(profileImageView, alignment: .center),
              usernameLabel)
    }
}

class MatchesMessagesController: LBTAListController<MatchCell, UIColor>, UICollectionViewDelegateFlowLayout {

    let customNavBar = MatchesNavBar()

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 140)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        items = [
            .red, .blue, .green, .purple, .orange
        ]

        collectionView.backgroundColor = .white

        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)

        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))

        collectionView.contentInset.top = 150
    }

    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }

}
