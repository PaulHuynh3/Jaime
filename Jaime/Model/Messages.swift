//
//  Messages.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-08.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import Firebase

struct Message {
    let text, fromId, toId: String
    let timestamp: Timestamp

    let isFromCurrentLoggedUser: Bool

    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())

        self.isFromCurrentLoggedUser = Auth.auth().currentUser?.uid == self.fromId
    }
}
