//
//  NewsAPIManager.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 11.05.2022.
//

import Foundation

class NewsAPIManager {
    typealias ArticlesResponse = (total: Int, articles: [Article])
    
    func fetchArticles(page: Int, query: String?, sources: String?, country: String?, category: String?, completion: @escaping ((ArticlesResponse) -> Void)) {
        guard let url = Endpoint.topHeadlines(page: page, query: query, sources: sources, country: country, category: category).url else { return }
   
        DataLoader.get(from: url) { (result: Result<TopHeadlinesResponse, DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let results):
                completion((total: results.totalResults, articles: results.articles))
            }
        }
    }
    
    //        guard let url = Endpoint.sources(country: nil, category: Category.general.string).url else { return }
    //                DataLoader.get(from: url) { (result: Result<SourcesResponse, DataError>) in
    //                    switch result {
    //                    case .failure(let error):
    //                        print(error.localizedDescription)
    //                    case .success(let results):
    //                        print(results.sources.count)
    //                    }
    //                }
}
