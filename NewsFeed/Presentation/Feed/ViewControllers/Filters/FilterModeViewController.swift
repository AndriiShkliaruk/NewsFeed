//
//  FilterModeViewController.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 13.05.2022.
//

import UIKit

class FilterModeViewController: UIViewController, Storyboarded {
    @IBOutlet private weak var filterItemsTableView: UITableView!
    
    var mode: FilterMode?
    var viewModel: FilterModeViewModel?
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        setupFilterItemsTableView()
        setupSpinner()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard mode == .sources else { return }
        spinner.startAnimating()
        viewModel?.fetchSources()
    }
    
    private func setupFilterItemsTableView() {
        filterItemsTableView.delegate = self
        filterItemsTableView.dataSource = self
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: filterItemsTableView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: filterItemsTableView.centerYAnchor).isActive = true
    }
}

extension FilterModeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.filterItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = viewModel?.filterItems[indexPath.row].name
        cell.accessoryType = (viewModel?.filterItems[indexPath.row].isSelected ?? false) ? .checkmark : .none
        cell.tintColor = .black
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel?.selectFilterItem(at: indexPath.row)
        filterItemsTableView.reloadData()
    }
}

extension FilterModeViewController: FetchCompletionDelegate {
    func onFetchCompleted() {
        filterItemsTableView.reloadData()
        spinner.stopAnimating()
    }
}
