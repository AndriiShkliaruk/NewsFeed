//
//  FeedViewModel.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 11.05.2022.
//

import Foundation

class FeedViewModel {
    let apiManager = NewsAPIManager()
    var total = 0
    var articles: [Article] = []
    
    var page = 1
    var query: String?
    var sources: String?
    var country: Country? = .us
    var category: Category?
    
    func fetchArticles(_ completion: (() -> Void)?) {
        apiManager.fetchArticles(page: page, query: query, sources: sources, country: country?.string, category: category?.string) { [weak self] apiResponse in
            self?.total = apiResponse.total
            self?.articles = apiResponse.articles
            completion?()
        }
    }
}
