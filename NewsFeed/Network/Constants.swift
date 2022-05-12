//
//  Constants.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 10.05.2022.
//

import Foundation

enum StringConstants: String, Stringable {
    case scheme = "https"
    case host = "newsapi.org"
    case apiKey = "d439eb3365304c5d88fa5e8399a36cdb"
}

enum IntConstants: Int {
    case pageSize = 15
}

enum NewsAPIPath: String, Stringable {
    case topHeadlines = "/v2/top-headlines"
    case sources = "/v2/top-headlines/sources"
}

enum NewsAPIQueryItem: String, Stringable {
    case apiKey
    case pageSize
    case page
    case query = "q"
    case sources
    case country
    case category
    
    func urlQueryItem(value: String?) -> URLQueryItem {
        return URLQueryItem(name: self.string, value: value)
    }
}

enum Category: String, Stringable {
    case business, entertainment, general, health, science, sports, technology
}

enum Country: String, Stringable {
    case ae, ar, at, au, be, bg, br, ca, ch, cn, co, cu, cz, de, eg, fr, gb, gr, hk, hu, id, ie, il, it, jp, kr, lt, lv, ma, mx, my, ng, nl, no, nz, ph, pl, pt, ro, rs, ru, sa, se, sg, si, sk, th, tr, tw, ua, us, ve, za
}
