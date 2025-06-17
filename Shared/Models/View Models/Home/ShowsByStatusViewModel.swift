//
//  ShowsByStatusViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 8/16/24.
//

import Foundation

class ShowsByStatusViewModel: ObservableObject {
    
    @Published var shows: [Show]? = nil
    @Published var isLoading = true
    
    @MainActor
    func setShows(shows: [Show]) {
        self.shows = shows
    }
    
    @MainActor
    func setIsLoading(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func loadShowsByStatus(userId: String, statusId: Int? = nil, limit: Int? = nil) async {
        await setIsLoading(isLoading: true)
        let statusArray: [Int]? = statusId == nil ? nil : [statusId!]
        let shows = await getShowsForUserByStatuses(statusIds: statusArray, limit: limit, userId: userId)
        await setShows(shows: shows)
        await setIsLoading(isLoading: false)
    }
    
    func loadShowsByStatuses(userId: String, statusIds: [Int]? = nil, limit: Int? = nil) async {
        await setIsLoading(isLoading: true)
        let shows = await getShowsForUserByStatuses(statusIds: statusIds, limit: limit, userId: userId)
        await setShows(shows: shows)
        await setIsLoading(isLoading: false)
    }
    
}
