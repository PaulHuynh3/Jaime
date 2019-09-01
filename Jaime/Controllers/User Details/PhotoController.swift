//
//  PhotoController.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-09-01.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class PhotoController: UIViewController {

    let imageView = UIImageView(image: #imageLiteral(resourceName: "aGirl4"))

    init(imageUrl: String) {

        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

    }

}
