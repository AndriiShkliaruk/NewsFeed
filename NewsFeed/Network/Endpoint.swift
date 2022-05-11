//
//  Endpoint.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 10.05.2022.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = StringConstants.scheme.string
        components.host = StringConstants.host.string
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
    
    
    static func topHeadlines(page: Int, query: String?, sources: String?, country: String?, category: String?) -> Endpoint {
        var queryItems = [getAPIKeyQueryItem(), urlQueryItem(for: .pageSize, value: String(IntConstants.pageSize.rawValue))]
        queryItems.append(urlQueryItem(for: .page, value: String(page)))
        
        if let query = query {
            queryItems.append(urlQueryItem(for: .query, value: query))
        }
        
        if let sources = sources {
            queryItems.append(urlQueryItem(for: .sources, value: sources))
        } else {
            if let country = country {
                queryItems.append(urlQueryItem(for: .country, value: country))
            }
            
            if let category = category {
                queryItems.append(urlQueryItem(for: .category, value: category))
            }
        }
        
        return Endpoint(path: NewsAPIPath.topHeadlines.string, queryItems: queryItems)
    }
    
    static func sources(country: String?, category: String?) -> Endpoint {
        var queryItems = [getAPIKeyQueryItem()]
        
        if let country = country {
            queryItems.append(urlQueryItem(for: .country, value: country))
        }
        
        if let category = category {
            queryItems.append(urlQueryItem(for: .category, value: category))
        }
        
        return Endpoint(path: NewsAPIPath.sources.string, queryItems: queryItems)
    }
    
    private static func getAPIKeyQueryItem() -> URLQueryItem {
        return urlQueryItem(for: .apiKey, value: StringConstants.apiKey.string)
    }
    
    private static func urlQueryItem(for apiItem: NewsAPIQueryItem, value: String?) -> URLQueryItem {
        return apiItem.urlQueryItem(value: value)
    }
}
