//
//  LoadingCell.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 12.05.2022.
//

import UIKit

class LoadingCell: UITableViewCell {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    static let identifier = "LoadingCell"
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
}
