//
//  ShowRatingsViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/12/24.
//

import Foundation

class ShowRatingsViewModel: ObservableObject {
    
    @Published var ratingCounts: [Rating:Int]? = nil
    
    @MainActor
    func setRatingCounts(counts: [Rating:Int]) {
        self.ratingCounts = counts
    }
    
    func loadRatingCounts(showId: Int) async {
        let counts = await getRatingCountsForShow(showId: showId)
        await setRatingCounts(counts: counts)
    }
    
}
