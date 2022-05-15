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
    var delegate: UpdateCompletionDelegate?
    
    var total = 0
    var articlesViewModels = [ArticleViewModel]()
    private var articles = [Article]()
    
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
        
        apiManager.fetchArticles(page: currentPage, query: query, sources: sources, country: country, category: category) { [unowned self] apiResponse in
            if isFirstPage {
                self.articles.removeAll()
            }
            self.articles.append(contentsOf: apiResponse.articles)
            self.total = apiResponse.total
            self.generateArticlesViewModels()
            DispatchQueue.main.async {
                self.updateArticlesViewModelsStates()
            }
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
    
    func updateArticlesViewModelsStates() {
        getStoredArticles()
        articlesViewModels.forEach { article in
            article.isSaved = storedArticles.contains(where: { $0.title == article.title }) ? true : false
        }
        delegate?.onUpdateCompleted()
    }
    
    private func generateArticlesViewModels() {
        articlesViewModels = articles.map { ArticleViewModel($0, imageLoader: imageLoader) }
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
