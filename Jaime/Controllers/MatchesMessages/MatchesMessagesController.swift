//
//  MatchesMessagesController.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-02.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import LBTATools
import Firebase

class MatchesMessagesController: LBTAListHeaderController<MatchCell, Match, MatchesHeader>, UICollectionViewDelegateFlowLayout {

    override func setupHeader(_ header: MatchesHeader) {
        header.matchesHorizontalController.rootMatchesController = self
    }

    func didSelectMatchFromHeader(match: Match) {
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }

    let customNavBar = MatchesNavBar()

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 140)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = items[indexPath.row]
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchMatches()

        collectionView.backgroundColor = .white

        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)

        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))

        collectionView.contentInset.top = 150
    }

    fileprivate func fetchMatches() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").getDocuments { (querySnapshot, err) in

            if let err = err {
                print("Failed to fetch matches:", err)
                return
            }

            print("Here are my matches documents")

            var matches = [Match]()

            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                matches.append(.init(dictionary: dictionary))
            })

            self.items = matches
            self.collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }

    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }

}
