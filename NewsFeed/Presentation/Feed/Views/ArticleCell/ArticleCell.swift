//
//  ArticleCell.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 11.05.2022.
//

import UIKit

class ArticleCell: UITableViewCell {
    @IBOutlet private weak var favouritesImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    
    static let identifier = "ArticleCell"
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        authorLabel.text = article.author
        sourceLabel.text = article.source.name
    }
    
    func setImage(image: UIImage) {
        mainImageView.image = image
    }
}
