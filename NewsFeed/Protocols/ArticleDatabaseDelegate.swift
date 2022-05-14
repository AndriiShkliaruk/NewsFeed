//
//  ArticleDatabaseDelegate.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 14.05.2022.
//

import Foundation

protocol ArticleDatabaseDelegate {
    func updateArticleInDatabase(_ articleViewModel: ArticleViewModel)
}
