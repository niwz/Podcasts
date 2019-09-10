//
//  MainTabBarController.swift
//  Podcasts
//
//  Created by Nicholas Wong on 9/6/19.
//  Copyright © 2019 Nicholas Wong. All rights reserved.
//

import UIKit
import Stevia

class MainTabBarController: UITabBarController {

    let playerDetailView = PlayerDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .purple
        viewControllers = [
            createNavController(viewController: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            createNavController(viewController: UIViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            createNavController(viewController: UIViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
        setupPlayerDetailView()
    }

    //MARK:- Player View
    private func setupPlayerDetailView() {
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        playerDetailView.fillHorizontally().bottom(view.frame.height).top(view.frame.height)
    }

    @objc func maximizePlayer() {
        guard let topConstraint = playerDetailView.topConstraint else { return }
        guard let bottomConstraint = playerDetailView.bottomConstraint else { return }
        NSLayoutConstraint.deactivate([topConstraint, bottomConstraint])
        playerDetailView.top(0).bottom(0)
        playerDetailView.miniPlayerView.alpha = 0
        playerDetailView.maximizedStackView.alpha = 1
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: self.tabBar.frame.height)
        }
    }

    @objc func minimizePlayer() {
        guard let topConstraint = playerDetailView.topConstraint else { return }
        guard let bottomConstraint = playerDetailView.bottomConstraint else { return }
        NSLayoutConstraint.deactivate([topConstraint, bottomConstraint])
        playerDetailView.Top == tabBar.Top - 100
        playerDetailView.bottom(0)
        playerDetailView.miniPlayerView.alpha = 1
        playerDetailView.maximizedStackView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
        }
    }
}

fileprivate func createNavController(viewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
    let navController = UINavigationController(rootViewController: viewController)
    viewController.navigationItem.title = title
    navController.tabBarItem.title = title
    navController.tabBarItem.image = image
    return navController
}
