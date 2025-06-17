//
//  ShowTileImageCache.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/5/24.
//

import Foundation
import UIKit

class ShowTileCacheManager {
    
    static let instance = ShowTileCacheManager()
    private init() {}
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 500
        cache.totalCostLimit = 1024 * 1024 * 1024 // 1 GB
        return cache
    }()
    
    var imagesLoading = Set<String>()
    
    func add(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
    }
    
    func remove(name: String) {
        imageCache.removeObject(forKey: name as NSString)
    }
    
    func get(name: String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
    
}
