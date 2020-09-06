//
//  FirebaseService.swift
//  Jaime
//
//  Created by Paul Huynh on 2020-09-05.
//  Copyright © 2020 Paul Huynh. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService: FirebaseServiceDelegate {
    typealias Result<T, V: Error> = (T?, V?) -> Void

    // MARK: - Singleton

    static var shared = FirebaseService()
    private init() {}

    var userUid: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    func createUser(email: String, password: String, completion: @escaping Result<AuthDataResult, Error>) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            completion(authDataResult, error)
        }
    }

    func saveImageToStorage(fileName: String, image: UIImage, completion: @escaping Result<URL, Error>) {
        let storage = Storage.storage().reference(withPath: "/images/\(fileName)")
        let imageData = image.jpegData(compressionQuality: 0.75) ?? Data()
        storage.putData(imageData, metadata: nil) { (_, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            storage.downloadURL { (url, err) in
                if let err = err {
                    completion(nil, err)
                    return
                }
                completion(url, err)
            }
        }
    }


    func saveUserInfoToFirestore(withPath collectionPath: String, userInfo: [String: Any], completion: @escaping ((Error?) -> Void)) {
        Firestore.firestore().collection(collectionPath).document(Auth.auth().currentUser?.uid ?? "").setData(userInfo) { (err) in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
        }
    }
}

protocol FirebaseServiceDelegate {
    var userUid: String { get }
    func createUser(email: String, password: String, completion: @escaping FirebaseService.Result<AuthDataResult, Error>)
    func saveImageToStorage(fileName: String, image: UIImage, completion: @escaping FirebaseService.Result<URL, Error>)
    func saveUserInfoToFirestore(withPath collectionPath: String, userInfo: [String: Any], completion: @escaping ((Error?) -> Void))
}