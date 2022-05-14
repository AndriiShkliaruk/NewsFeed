//
//  FeedViewModel.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 11.05.2022.
//

import Foundation

class FeedViewModel {
    let filtersIcon = "list.bullet.rectangle"
    private let imageLoader = ImageLoader()
    private let realmManager = RealmManager.sharedInstance
    private var storedArticles = [ArticleViewModel]()
    let apiManager = NewsAPIManager()
    let filtersViewModel = FiltersViewModel()
    var delegate: FetchCompletionDelegate?
    
    var total = 0
    var articles: [ArticleViewModel] = []
    
    private var currentPage = 1
    private var query: String?
    private var sources: String?
    private var country: String?
    private var category: String?
    
    private var isFetching = false
    var hasOneMorePage: Bool {
        let pagesCount = ceil(Double(total) / Double(IntConstants.pageSize.rawValue))
        return Int(pagesCount) > currentPage
    }
    
    var isFirstPage: Bool {
        currentPage == 1
    }
    
    init() {
        country = Country.us.string
        filtersViewModel.filterModeViewModel.selectDefaultCountry(.us)
    }
    
    func fetchArticles() {
        guard !isFetching else { return }
        isFetching = true
        getStoredArticles()
        apiManager.fetchArticles(page: currentPage, query: query, sources: sources, country: country, category: category) { [unowned self] apiResponse in
            self.total = apiResponse.total
            if isFirstPage {
                self.articles = articleViewModels(from: apiResponse.articles)
            } else {
                self.articles.append(contentsOf: articleViewModels(from: apiResponse.articles))
            }
            self.updateArticlesStates()
            self.delegate?.onFetchCompleted()
            isFetching = false
        }
    }
    
    func fetchNextPage() {
        guard hasOneMorePage else { return }
        currentPage += 1
        fetchArticles()
    }
    
    func fetchFirstPage() {
        currentPage = 1
        fetchArticles()
    }
    
    func fetchWithQuery(_ newQuery: String) {
        query = newQuery
        fetchFirstPage()
    }
    
    private func articleViewModels(from articles: [Article]) -> [ArticleViewModel] {
        return articles.map { ArticleViewModel($0, imageLoader: imageLoader) }
    }
    
    private func updateArticlesStates() {
        articles.forEach { article in
            article.isSaved = storedArticles.contains(where: { $0.title == article.title }) ? true : false
        }
    }
    
    private func getStoredArticles() {
        let storedInDBArticles = realmManager.get()
        storedArticles = storedInDBArticles.map { ArticleViewModel(managedObject: $0) }
    }
    
    func didApplyFilters() {
        category = filtersViewModel.filterModeViewModel.selectedCategory
        country = filtersViewModel.filterModeViewModel.selectedCountry
        sources = filtersViewModel.filterModeViewModel.selectedSourcesIDs
        fetchFirstPage()
    }
    
    func updateArticleInDatabase(_ articleViewModel: ArticleViewModel) {
        let articleObject = articleViewModel.managedObject()
        realmManager.toggle(object: articleObject)
    }
}
