//
//  FeedCoordinator.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 10.05.2022.
//

import UIKit

class FeedCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinator: TabBarCoordinator?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = FeedViewController.instantiate()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func moveToFilters(with viewModel: FiltersViewModel, delegate: FiltersDelegate) {
        let viewController = FiltersViewController.instantiate()
        viewController.coordinator = self
        viewController.viewModel = viewModel
        viewController.delegate = delegate
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func moveToFilter(viewModel: FilterModeViewModel) {
        let viewController = FilterModeViewController.instantiate()
        viewController.viewModel = viewModel
        viewController.mode = viewModel.mode
        navigationController.pushViewController(viewController, animated: true)
    }
}
