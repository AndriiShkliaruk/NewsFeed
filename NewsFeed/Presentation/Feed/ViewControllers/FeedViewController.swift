//
//  FeedViewController.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 10.05.2022.
//

import UIKit

protocol FeedViewControllerDelegate {
    func onFetchCompleted()
}

class FeedViewController: UIViewController, Storyboarded {
    @IBOutlet private weak var articlesTableView: UITableView!
    
    var coordinator: FeedCoordinator?
    private var timer: Timer?
    private let viewModel = FeedViewModel()
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupArticlesTableView()
        setupSearchBar()
        setupSpinner()
        setupRefreshControl()
    }
    
    private func setupArticlesTableView() {
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        articlesTableView.register(UINib(nibName: ArticleCell.identifier, bundle: nil), forCellReuseIdentifier: ArticleCell.identifier)
        articlesTableView.register(UINib(nibName: LoadingCell.identifier, bundle: nil), forCellReuseIdentifier: LoadingCell.identifier)
        viewModel.fetchFirstPage()
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: articlesTableView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: articlesTableView.centerYAnchor).isActive = true
    }
    
    private func setupRefreshControl() {
        articlesTableView.refreshControl = UIRefreshControl()
        articlesTableView.refreshControl?.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
    }
    
    @objc private func refreshArticles() {
        viewModel.fetchFirstPage()
        articlesTableView.refreshControl?.endRefreshing()
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.articles.count
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == articlesTableView, viewModel.total > 0 else { return }
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            viewModel.fetchNextPage()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let articleCellsCount = viewModel.articles.count
        let loadingCellsCount = viewModel.hasOneMorePage ? 1 : 0
        return section == 0 ? articleCellsCount : loadingCellsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = articlesTableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as? ArticleCell else { return UITableViewCell() }
            cell.configure(with: viewModel.articles[indexPath.row])
            return cell
        } else {
            guard let cell = articlesTableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier, for: indexPath) as? LoadingCell else { return UITableViewCell() }
            cell.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 ? 80 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.moveToArticle(with: viewModel.articles[indexPath.row].url)
    }
}

extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        spinner.startAnimating()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { [weak self] _ in
            self?.viewModel.fetchWithQuery(searchText)
        })
    }
}

extension FeedViewController: FeedViewControllerDelegate {
    func onFetchCompleted() {
        articlesTableView.reloadData()
        spinner.stopAnimating()
    }
}
