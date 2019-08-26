//
//  SwipingPhotosController.swift
//  Jaime
//
//  Created by Paul Huynh on 2019-08-25.
//  Copyright © 2019 Paul Huynh. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource {

    let controllers = [
        PhotoController(image: #imageLiteral(resourceName: "aGirl4")),
        PhotoController(image: #imageLiteral(resourceName: "aGirl2")),
        PhotoController(image: #imageLiteral(resourceName: "aGirl3")),
        PhotoController(image: #imageLiteral(resourceName: "kelly4")),
        PhotoController(image: #imageLiteral(resourceName: "like_circle"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = .white
        setViewControllers([controllers.first!], direction: .forward, animated: false)
    }


    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0

        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
}

class PhotoController: UIViewController {

    let imageView = UIImageView(image: #imageLiteral(resourceName: "aGirl4"))

    init(image: UIImage) {
        self.imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFit

    }

}
