//
//  SimilarShowsViewModel.swift
//  TV Show App
//
//  Created by AJ Glodowski on [Current Date]
//

import Foundation

class SimilarShowsViewModel: ObservableObject {
    
    @Published var similarShows: [Show]? = nil
    @Published var isLoading: Bool = false
    
    @MainActor
    func setSimilarShows(shows: [Show]) {
        self.similarShows = shows
        self.isLoading = false
    }
    
    @MainActor
    func setLoading(_ loading: Bool) {
        self.isLoading = loading
    }
    
    func loadSimilarShows(showId: Int, limit: Int = 10) async {
        await setLoading(true)
        
        // Get similar show IDs
        let similarShowIds = await getSimilarShows(showId: showId, limit: limit)
        
        // Fetch full show data for each ID
        var shows: [Show] = []
        for showId in similarShowIds {
            if let show = await getShow(showId: showId) {
                shows.append(show)
            }
        }
        
        await setSimilarShows(shows: shows)
    }
} 