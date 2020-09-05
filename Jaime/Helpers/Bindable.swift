//
//  Bindable.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-07-14.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet{
            observer?(value)
        }
    }

    var observer: ((T?) -> ())?

    func bind(observer: @escaping (T?)->()) {
        self.observer = observer
    }
}
