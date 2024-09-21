//
//  ShowsByStatusViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/16/24.
//

import Foundation

class ShowsByStatusViewModel: ObservableObject {
    
    @Published var shows: [Show]? = nil
    
    @MainActor
    func setShows(shows: [Show]) {
        self.shows = shows
    }
    
    func loadShowsByStatus(userId: String, statusId: Int? = nil, limit: Int? = nil) async {
        let shows = await getShowsForUserByStatus(statusId: statusId, limit: limit, userId: userId)
        dump(shows)
        await setShows(shows: shows)
    }
    
}
