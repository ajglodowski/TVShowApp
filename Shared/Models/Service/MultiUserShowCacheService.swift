//
//  MultiUserShowCacheService.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 1/15/25.
//

import Foundation
import SwiftUI

class MultiUserShowCacheService: ObservableObject {
    static let shared = MultiUserShowCacheService()
    
    @Published private var cache: [Int: ShowMultiUserData] = [:]
    @Published private var loadingShows: Set<Int> = []
    
    private init() {}
    
    func getCachedData(for showId: Int) -> ShowMultiUserData? {
        return cache[showId]
    }
    
    func isLoading(showId: Int) -> Bool {
        return loadingShows.contains(showId)
    }
    
    func preloadShows(_ showIds: [Int]) async {
        let uncachedShows = showIds.filter { cache[$0] == nil && !loadingShows.contains($0) }
        
        guard !uncachedShows.isEmpty else { return }
        
        await MainActor.run {
            for showId in uncachedShows {
                loadingShows.insert(showId)
            }
        }
        
        // Load data for all uncached shows concurrently
        await withTaskGroup(of: (Int, ShowMultiUserData).self) { group in
            for showId in uncachedShows {
                group.addTask {
                    let data = await getMultiUserShowData(showId: showId)
                    return (showId, data)
                }
            }
            
            for await (showId, data) in group {
                await MainActor.run {
                    self.cache[showId] = data
                    self.loadingShows.remove(showId)
                }
            }
        }
    }
    
    func loadSingleShow(_ showId: Int) async -> ShowMultiUserData {
        // Check cache first
        if let cachedData = cache[showId] {
            return cachedData
        }
        
        // Mark as loading for UI state
        await MainActor.run {
            loadingShows.insert(showId)
        }
        
        // Load the data (concurrent requests will just duplicate work, which is fine)
        let data = await getMultiUserShowData(showId: showId)
        
        await MainActor.run {
            cache[showId] = data
            loadingShows.remove(showId)
        }
        
        return data
    }
    
    func clearCache() {
        cache.removeAll()
        loadingShows.removeAll()
    }
} 