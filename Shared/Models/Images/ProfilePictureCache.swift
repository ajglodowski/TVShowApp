//
//  ProfilePictureCache.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/5/24.
//

import Foundation
import UIKit

class ProfilePictureCacheManager {
    
    static let instance = ProfilePictureCacheManager()
    private init() {}
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 500
        cache.totalCostLimit = 1024 * 1024 * 1024 // 1 GB
        return cache
    }()
    
    var imagesLoading = Set<String>()
    
    func add(image: UIImage, userId: String) {
        imageCache.setObject(image, forKey: userId as NSString)
    }
    
    func remove(userId: String) {
        imageCache.removeObject(forKey: userId as NSString)
    }
    
    func get(userId: String) -> UIImage? {
        return imageCache.object(forKey: userId as NSString)
    }
    
}
