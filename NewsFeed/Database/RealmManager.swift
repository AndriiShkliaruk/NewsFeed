//
//  RealmManager.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 14.05.2022.
//

import Foundation
import RealmSwift

class RealmManager {
    private var database: Realm
    static let sharedInstance = RealmManager()
    
    private init() {
        database = try! Realm()
    }
    
    func get() -> Results<ArticleObject> {
        let results: Results<ArticleObject> = database.objects(ArticleObject.self)
        return results
    }
    
    func save(object: ArticleObject) {
        try! database.write {
            database.add(object)
        }
    }
    
    func deleteByTitle(_ title: String) {
        guard let objectToDelete = getObjectByTitle(title) else { return }
        delete(object: objectToDelete)
    }
    
    func toggle(object: ArticleObject) {
        if let objectToDelete = getObjectByTitle(object.title) {
            delete(object: objectToDelete)
        } else {
            save(object: object)
        }
    }
    
    private func delete(object: ArticleObject) {
        try! database.write {
            database.delete(object)
        }
    }
    
    private func getObjectByTitle(_ title: String) -> ArticleObject? {
        return database.objects(ArticleObject.self).filter("title == %@", title).first
    }
}
