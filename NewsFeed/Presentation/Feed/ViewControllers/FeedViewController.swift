//
//  FeedViewController.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 10.05.2022.
//

import UIKit

class FeedViewController: UIViewController, Storyboarded {
    @IBOutlet private weak var articlesTableView: UITableView!
    
    var coordinator: FeedCoordinator?
    private var timer: Timer?
    private let viewModel = FeedViewModel()
    
    private lazy var filtersBarButtonItem: UIBarButtonItem = {
        let icon = UIImage(systemName: viewModel.filtersIcon)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(filtersBarButtonTapped))
    }()
    
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
        setupNavigationBar()
        viewModel.fetchFirstPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !viewModel.articlesViewModels.isEmpty else { return }
        viewModel.updateArticlesViewModelsStates()
    }
    
    private func setupArticlesTableView() {
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        articlesTableView.register(UINib(nibName: ArticleCell.identifier, bundle: nil), forCellReuseIdentifier: ArticleCell.identifier)
        articlesTableView.register(UINib(nibName: LoadingCell.identifier, bundle: nil), forCellReuseIdentifier: LoadingCell.identifier)
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
        spinner.startAnimating()
    }
    
    private func setupRefreshControl() {
        articlesTableView.refreshControl = UIRefreshControl()
        articlesTableView.refreshControl?.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = filtersBarButtonItem
    }
    
    @objc private func refreshArticles() {
        viewModel.fetchFirstPage()
        articlesTableView.refreshControl?.endRefreshing()
    }
    
    @objc private func filtersBarButtonTapped() {
        coordinator?.moveToFilters(with: viewModel.filtersViewModel, delegate: self)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let articleCellsCount = viewModel.articlesViewModels.count
        let loadingCellsCount = viewModel.hasOneMorePage ? 1 : 0
        return section == 0 ? articleCellsCount : loadingCellsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = articlesTableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as? ArticleCell else { return UITableViewCell() }
            cell.configure(for: .feed, viewModel: viewModel.articlesViewModels[indexPath.row], delegate: self)
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
        tableView.deselectRow(at: indexPath, animated: false)
        coordinator?.parentCoordinator?.presentWebViewArticle(with: viewModel.articlesViewModels[indexPath.row].url)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            viewModel.fetchNextPage()
        }
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

extension FeedViewController: FiltersDelegate {
    func applyFilters() {
        articlesTableView.contentOffset = .zero
        viewModel.didApplyFilters()
    }
}

extension FeedViewController: UpdateCompletionDelegate {
    func onUpdateCompleted() {
        articlesTableView.reloadData()
        spinner.stopAnimating()
    }
}

extension FeedViewController: ArticleDatabaseDelegate {
    func updateArticleInDatabase(_ articleViewModel: ArticleViewModel) {
        viewModel.updateArticleInDatabase(articleViewModel)
    }
}
