//
//  UserDetailsControllerViewController.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-08-25.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class UserDetailsControllerViewController: UIViewController, UIScrollViewDelegate {

    //lazy soo the function is able to access self
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        //for draggin the image without the safearea bounce
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()

    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jane4"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name 30\nDoctor\nSome bio text down below"
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.addSubview(imageView)
        //use fram inside uiscrollview instead of autolayout (anchors like for label)
        imageView.frame = CGRect(x: 0, y: 0, width:  view.frame.width, height: view.frame.width)

        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: imageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))

    }

    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //expand the frame of image using the contentOffSet
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        //prevent the image from going small if i scroll up
        width = max(view.frame.width, width)
        //minimum value prevents the image from shifting left and right
        imageView.frame = CGRect(x: min(0, -changeY) , y: min(0, -changeY), width: width, height: width)
    }

}
