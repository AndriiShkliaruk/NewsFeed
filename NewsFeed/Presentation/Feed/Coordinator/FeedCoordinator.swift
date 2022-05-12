//
//  FeedCoordinator.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 10.05.2022.
//

import UIKit

class FeedCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = FeedViewController.instantiate()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func moveToArticle(with url: String) {
        let viewController = ArticleViewController.instantiate()
        viewController.url = URL(string: url)
        navigationController.pushViewController(viewController, animated: true)
    }
}
