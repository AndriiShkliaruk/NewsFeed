//
//  NewsAPIManager.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 11.05.2022.
//

import Foundation

class NewsAPIManager {
    typealias ArticlesResult = (total: Int, articles: [Article])
    
    func fetchArticles(page: Int, query: String?, sources: String?, country: String?, category: String?, completion: @escaping (ArticlesResult) -> Void) {
        guard let url = Endpoint.topHeadlines(page: page, query: query, sources: sources, country: country, category: category).url else { return }
print(url)
        DataLoader.get(from: url) { (result: Result<ArticlesResponse, DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let results):
                completion((total: results.totalResults, articles: results.articles))
            }
        }
    }
    
    func fetchSources(country: Country?, category: Category?, completion: @escaping ([Source]) -> Void) {
        guard let url = Endpoint.sources(country: country?.string, category: category?.string).url else { return }
        
        DataLoader.get(from: url) { (result: Result<SourcesResponse, DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let results):
                completion(results.sources)
            }
        }
    }
    
//    func loadData(from url: String, completion: @escaping (Data) -> Void) {
//        guard let url = URL(string: url) else { return }
//        DataLoader.get(from: url) { (result: Result<Data, DataError>) in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .success(let data):
//                completion(data)
//            }
//        }
//    }
}
