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
            guard let url = URL(string: urlToImage) else { return }
            
            let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                guard let imageData = data else { return }
                guard let image = UIImage(data: imageData) else { return }
                
                DispatchQueue.main.async {
                    completion(image)
                    self?.cache.setObject(image, forKey: NSString(string: urlToImage))
                }
            }
            dataTask.resume()
        }
    }
}
