//
//  RecentMessage.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-15.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import Foundation
import Firebase

struct RecentMessage {
    let text, uid, name, profileImageUrl: String
    let timestamp: Timestamp

    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""

        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
