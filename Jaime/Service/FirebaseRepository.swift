//
//  FirebaseRepository.swift
//  Jaime
//
//  Created by Paul Huynh on 2020-09-05.
//  Copyright © 2020 Paul Huynh. All rights reserved.
//

import UIKit
import Firebase

class FirebaseRepository {
    // MARK: - Singleton

    static let shared = FirebaseRepository()
    private init() {}

    private var service = FirebaseService.shared

    var userUid: String {
        return service.userUid
    }

    func createUser(email: String, password: String, completion: @escaping ((Error?) -> Void)) {
        service.createUser(email: email, password: password) { (result, error) in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }

    func saveImageToStorage(fileName: String, image: UIImage, completion: @escaping ((URL?, Error?) -> Void)) {
        service.saveImageToStorage(fileName: fileName, image: image) { (url, err) in
            if let err = err {
                completion(nil, err)
            }
            completion(url, nil)
        }
    }

    func saveInfoToFireStore(withPath collectionPath: String, userDict: [String: Any], completion: @escaping ((Error?) -> Void)) {
        service.saveUserInfoToFirestore(withPath: collectionPath, userInfo: userDict, completion: completion)
    }
}
