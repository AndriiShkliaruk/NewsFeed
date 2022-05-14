//
//  ArticleViewModel.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 13.05.2022.
//

import UIKit

final class ArticleViewModel: Persistable {
    enum FavouriteCheckmark: String, Stringable, CaseIterable {
        case checked = "star.fill"
        case unchecked = "star"
    }
    
    let defaultImage = UIImage(systemName: "camera")
    
    let source: String
    let author: String?
    let title: String
    let description: String?
    let url: String
    var image: UIImage?
    let hasLoadedImage: Bool
    var imageDidLoad: ((UIImage) -> Void)?
    
    var isSaved = false
    var favouritesIconName: String {
        isSaved ? FavouriteCheckmark.checked.string : FavouriteCheckmark.unchecked.string
    }
    
    init(_ model: Article, imageLoader: ImageLoader) {
        source = model.source.name
        author = model.author
        title = model.title
        description = model.description
        url = model.url
        image = defaultImage
        
        if let urlToImage = model.urlToImage {
            hasLoadedImage = true
            imageLoader.get(from: urlToImage) { image in
                self.image = image
                self.imageDidLoad?(image)
            }
        } else {
            hasLoadedImage = false
        }
    }
    
    init(managedObject: ArticleObject) {
        source = managedObject.source
        author = managedObject.author
        title = managedObject.title
        description = managedObject.desc
        url = managedObject.url
        if let imageData = managedObject.image {
            hasLoadedImage = true
            image = UIImage(data: imageData)
        } else {
            hasLoadedImage = false
            image = defaultImage
        }
    }
    
    func managedObject() -> ArticleObject {
        let article = ArticleObject()
        article.source = source
        article.author = author
        article.title = title
        article.desc = description
        article.url = url
        article.image = hasLoadedImage ? image?.pngData() : nil
        return article
    }
    
    func toggleSaveState() {
        isSaved.toggle()
    }
}
