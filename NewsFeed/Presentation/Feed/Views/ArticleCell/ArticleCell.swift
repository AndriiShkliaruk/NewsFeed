//
//  ArticleCell.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 11.05.2022.
//

import UIKit

enum ArticleCellMode {
    case feed
    case favourites
}

class ArticleCell: UITableViewCell {
    @IBOutlet private weak var favouritesImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    
    static let identifier = "ArticleCell"
    private var viewModel: ArticleViewModel?
    private var delegate: ArticleDatabaseDelegate?
    
    func configure(for mode: ArticleCellMode, viewModel: ArticleViewModel, delegate: ArticleDatabaseDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        switch mode {
        case .feed:
            favouritesImageView.image = UIImage(systemName: viewModel.favouritesIconName)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favouritesButtonTapped))
            favouritesImageView.isUserInteractionEnabled = true
            favouritesImageView.addGestureRecognizer(tapGesture)
        case .favourites:
            favouritesImageView.isHidden = true
        }
        
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        authorLabel.text = viewModel.author
        sourceLabel.text = viewModel.source
        mainImageView.image = viewModel.image
        
        viewModel.imageDidLoad = { [weak self] image in
            self?.mainImageView.image = image
        }
    }
    
    @objc private func favouritesButtonTapped() {
        guard let viewModel = viewModel else { return }
        viewModel.toggleSaveState()
        favouritesImageView.image = UIImage(systemName: viewModel.favouritesIconName)
        delegate?.updateArticleInDatabase(viewModel)
    }
}
