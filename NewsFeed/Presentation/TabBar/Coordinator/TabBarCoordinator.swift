//
//  TabBarCoordinator.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 10.05.2022.
//

import UIKit

enum TabBarItem: Int {
    case feed
    case favourites
    
    var index: Int {
        rawValue
    }
    
    var description: String {
        switch self {
        case .feed:
            return "Feed"
        case .favourites:
            return "Favourites"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .feed:
            return UIImage(systemName: "newspaper")
        case .favourites:
            return UIImage(systemName: "star.square")
        }
    }
}

class TabBarCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    private let tabBarViewController = TabBarViewController()
    private let feedCoordinator = FeedCoordinator(UINavigationController())
    private let favouritesCoordinator = FavouritesCoordinator(UINavigationController())
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        tabBarViewController.coordinator = self
    }
    
    func start() {
        feedCoordinator.parentCoordinator = self
        feedCoordinator.start()
        let feedViewController = feedCoordinator.navigationViewController
        feedViewController.tabBarItem = generateTabBarItem(.feed)
         
        favouritesCoordinator.parentCoordinator = self
        favouritesCoordinator.start()
        let favouritesViewController = favouritesCoordinator.navigationViewController
        favouritesViewController.tabBarItem = generateTabBarItem(.favourites)
        
        tabBarViewController.viewControllers = [feedViewController, favouritesViewController]
        navigationController.pushViewController(tabBarViewController, animated: true)
    }
    
    func presentWebViewArticle(with url: String) {
        let viewController = ArticleViewController.instantiate()
        viewController.url = URL(string: url)
        navigationController.present(viewController, animated: true)
    }
    
    private func generateTabBarItem(_ item: TabBarItem) -> UITabBarItem {
        return UITabBarItem(title: item.description, image: item.icon, tag: item.index)
    }
    
}
