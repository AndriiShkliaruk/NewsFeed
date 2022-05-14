//
//  FavouritesViewController.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 10.05.2022.
//

import UIKit

class FavouritesViewController: UIViewController, Storyboarded {
    @IBOutlet private weak var favouritesTableView: UITableView!
    
    var coordinator: FavouritesCoordinator?
    private let viewModel = FavouritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavouritesTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getStoredArticles()
        favouritesTableView.reloadData()
    }
    
    private func setupFavouritesTableView() {
        favouritesTableView.delegate = self
        favouritesTableView.dataSource = self
        favouritesTableView.register(UINib(nibName: ArticleCell.identifier, bundle: nil), forCellReuseIdentifier: ArticleCell.identifier)
    }
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.storedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favouritesTableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as? ArticleCell else { return UITableViewCell() }
        cell.configure(for: .favourites, viewModel: viewModel.storedArticles[indexPath.row], delegate: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        coordinator?.parentCoordinator?.presentWebViewArticle(with: viewModel.storedArticles[indexPath.row].url)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.deleteArticleFromDatabase(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
