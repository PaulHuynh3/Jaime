//
//  Firebase+Utils.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-08-25.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import Foundation
import Firebase

extension Firestore {
    func fetchCurrentUser(completion: @escaping (User?, Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                completion(nil, err)
                return
            }

            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user, nil)
        }
    }
}
