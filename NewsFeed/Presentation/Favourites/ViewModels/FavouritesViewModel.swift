//
//  FavouritesViewModel.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 14.05.2022.
//

import Foundation

class FavouritesViewModel {
    private let realmManager = RealmManager.sharedInstance
    var storedArticles = [ArticleViewModel]()
    
    func getStoredArticles() {
        let storedInDBArticles = realmManager.get()
        storedArticles = storedInDBArticles.map { ArticleViewModel(managedObject: $0) }
    }
    
    func deleteArticleFromDatabase(at index: Int) {
        realmManager.deleteByTitle(storedArticles.remove(at: index).title)
    }
}
