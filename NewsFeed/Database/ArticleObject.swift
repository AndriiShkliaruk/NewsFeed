//
//  ArticleObject.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 14.05.2022.
//

import Foundation
import RealmSwift

final class ArticleObject: Object {
    @objc dynamic var source: String = ""
    @objc dynamic var author: String?
    @objc dynamic var title: String = ""
    @objc dynamic var desc: String?
    @objc dynamic var url: String = ""
    @objc dynamic var image: Data?
}
