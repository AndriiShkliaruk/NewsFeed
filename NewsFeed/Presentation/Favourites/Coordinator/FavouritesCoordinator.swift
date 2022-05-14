//
//  FavouritesCoordinator.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 10.05.2022.
//

import UIKit

class FavouritesCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: TabBarCoordinator?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = FavouritesViewController.instantiate()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
}
