//
//  FeedViewModel.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 11.05.2022.
//

import Foundation

class FeedViewModel {
    let apiManager = NewsAPIManager()
    var delegate: FeedViewControllerDelegate?
    
    var total = 0
    var articles: [Article] = []
    
    private var currentPage = 1
    private var query: String?
    private var sources: String?
    private var country: Country? = .us
    private var category: Category?
    
    private var isFetching = false
    var hasOneMorePage: Bool {
        let pagesCount = ceil(Double(total) / Double(IntConstants.pageSize.rawValue))
        return Int(pagesCount) - currentPage > 0
    }
    
    private func fetchArticles() {
        isFetching = true
        
        apiManager.fetchArticles(page: currentPage, query: query, sources: sources, country: country?.string, category: category?.string) { [unowned self] apiResponse in
            self.total = apiResponse.total
            self.articles.append(contentsOf: apiResponse.articles)
            print(articles.count)
            DispatchQueue.main.async {
                self.delegate?.onFetchCompleted()
            }
            isFetching = false
        }
    }
    
    func fetchNextPage() {
        guard !isFetching, hasOneMorePage else { return }
        currentPage += 1
        fetchArticles()
    }
    
    func fetchFirstPage() {
        currentPage = 1
        total = 0
        articles.removeAll()
        fetchArticles()
    }
    
    func fetchWithQuery(_ newQuery: String) {
        query = newQuery
        fetchFirstPage()
    }
}
