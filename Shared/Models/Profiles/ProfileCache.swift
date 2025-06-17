//
//  ProfileCache.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/11/24.
//

import Foundation

class ProfileCacheManager {
    
    static let instance = ProfileCacheManager()
    private init() {}
    
    private var store: [String: Profile] = [:] // Possibly swift to actual cache
    
    var imagesLoading = Set<String>()
    
    func add(profile: Profile, userId: String) {
        store[userId] = profile
    }
    
    func remove(userId: String) {
        store[userId] = nil
    }
    
    func get(userId: String) -> Profile? {
        return store[userId]
    }
    
}
