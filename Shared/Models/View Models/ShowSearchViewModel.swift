//
//  ShowSearchViewModel.swift
//  TV Show App (iOS)
//
//  Created by AJ Glodowski on 7/16/24.
//

import Foundation

class SearchShowViewModel: ObservableObject {
    
    @Published var searchResults: [Show]? = nil
    
    @MainActor
    func setSearchResults(shows: [Show]) {
        self.searchResults = shows
    }
    
    func findShows(searchText: String) async {
        let fetched = await findShowByName(searchText: searchText)
        await setSearchResults(shows: fetched)
    }
    
}
