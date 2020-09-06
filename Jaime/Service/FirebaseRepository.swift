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

    func signIn(email: String, password: String, completion: @escaping FirebaseService.FirebaseError<Error>) {
        service.signIn(email: email, password: password) { err in
            completion(err)
        }
    }

    func createUser(email: String, password: String, completion: @escaping FirebaseService.FirebaseError<Error>) {
        service.createUser(email: email, password: password) { (result, error) in
            completion(error)
        }
    }

    func saveImageToStorage(fileName: String, image: UIImage, completion: @escaping FirebaseService.Result<URL?, Error>) {
        service.saveImageToStorage(fileName: fileName, image: image) { (url, err) in
            completion(url, err)
        }
    }

    func saveInfoToFireStore(withPath collectionPath: String, userDict: [String: Any], completion: @escaping FirebaseService.FirebaseError<Error>) {
        service.saveUserInfoToFirestore(withPath: collectionPath, userInfo: userDict, completion: completion)
    }
}
