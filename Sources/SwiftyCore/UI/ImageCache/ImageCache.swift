//
//  ImageCache.swift
//  
//
//  Created by Borko Tomic on 13.12.20..
//

import Foundation
import UIKit

extension SwiftyCore.UI {
    private struct CacheReadyImage {
        let timestamp: Date
        let url: String
        let image: UIImage
    }
    struct ImageCache {
        static var shared = ImageCache()
        
        private var cache = [CacheReadyImage]()
        
        mutating func get(url: String) -> UIImage? {
            guard let cacheImage = cache.first(where: { $0.url == url }) else {
                return nil
            }
            cache.removeAll(where: { $0.url == cacheImage.url })
            cache.append(CacheReadyImage(timestamp: Date(), url: cacheImage.url, image: cacheImage.image))
            return cacheImage.image
        }
        
        mutating func add(url: String, image: UIImage) {
            guard !cache.contains(where: { $0.url == url }) else { return }
            if cache.count == SwiftyCore.UI.imageCacheSize {
                guard let urlToRemove = cache.sorted(by: { $0.timestamp < $1.timestamp }).first?.url else { return }
                cache.removeAll(where: { $0.url == urlToRemove })
            }
            cache.append(CacheReadyImage(timestamp: Date(), url: url, image: image))
        }
        
        mutating func remove(url: String) {
            cache.removeAll(where: { $0.url == url })
        }
        
        mutating func flush() {
            cache.removeAll()
        }
    }
}
