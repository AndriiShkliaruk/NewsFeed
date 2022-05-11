//
//  Source.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 11.05.2022.
//

import Foundation

struct SourcesResponse: Decodable {
    let sources: [Source]
}

struct Source: Decodable {
    let id: String?
    let name: String
}
