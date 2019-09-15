//
//  Match.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-15.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import Foundation

struct Match {
    let name, profileImageUrl, uid: String

    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
