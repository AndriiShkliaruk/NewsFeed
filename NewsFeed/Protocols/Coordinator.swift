//
//  Coordinator.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 10.05.2022.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

extension Coordinator {
    var navigationViewController: UIViewController {
        navigationController
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
