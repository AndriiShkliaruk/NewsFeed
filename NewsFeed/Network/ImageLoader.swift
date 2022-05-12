//
//  ImageLoader.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 12.05.2022.
//

import UIKit

class ImageLoader {
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    private let cache = NSCache<NSString, UIImage>()
    
    func get(from urlToImage: String, completion: @escaping (UIImage) -> Void) {
        if let image = cache.object(forKey: NSString(string: urlToImage)) {
            completion(image)
        } else {
            utilityQueue.async {
                guard let url = URL(string: urlToImage) else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    completion(image)
                    self.cache.setObject(image, forKey: NSString(string: urlToImage))
                }
            }
        }
    }
}
