//
//  FiltersViewController.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 13.05.2022.
//

import UIKit

class FiltersViewController: UIViewController, Storyboarded {
    @IBOutlet private weak var filtersTableView: UITableView!
    @IBOutlet private weak var applyButton: UIButton!
    
    var coordinator: FeedCoordinator?
    var viewModel: FiltersViewModel?
    var delegate: FiltersDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFiltersTableView()
    }
    
    private func setupUI() {
        applyButton.backgroundColor = .black
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.setTitleColor(.gray, for: .highlighted)
        applyButton.tintColor = .white
        applyButton.layer.cornerRadius = 10
    }
    
    private func setupFiltersTableView() {
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
    }
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        delegate?.applyFilters()
        coordinator?.back()
    }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.filterNames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = viewModel?.filterNames[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let viewModel = viewModel else { return }
        coordinator?.moveToFilter(viewModel: viewModel.filterWithMode(at: indexPath.row))
    }
}
